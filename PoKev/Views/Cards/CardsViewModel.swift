//
//  CardsViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import Foundation
import Observation

@Observable
final class CardsViewModel {
    enum Configuration {
        case set(_ set: PokemonTCGSet)
        case pokedexNumber(_ pokedexNumber: Int)
    }
    
    let configuration: Configuration
    
    private(set) var allCards = [PokemonTCGCard]()
    private var refinedCards = [PokemonTCGCard]() {
        didSet {
            cardsToDisplay = refinedCards
        }
    }
    private(set) var cardsToDisplay = [PokemonTCGCard]()
    private(set) var isFetchingCards = false
    let shouldShowPokedexButton: Bool
    let shouldShowSetButton: Bool
    private(set) var shouldShowNoResultsScreen = false
    
    private(set) var error: RequestError?
    var shouldPresentError = false
    
    var cardDetailIsPresented = false
    var selectedCard: PokemonTCGCard?
    
    var refinementMenuIsPresented = false
    var refinement: CardsRefinement
    
    var carouselViewIsPresented = false
    
    var searchText = "" {
        didSet {
            searchCards()
        }
    }
    
    var errorMessage: String {
        if let error = self.error {
            return "\(error.customMessage)"
        } else {
            return "Unknown error"
        }
    }
    
    var navigationTitle: String {
        switch configuration {
        case .set(let set):
            if set.name.hasSuffix("Set") {
                return set.name
            } else {
                return "\(set.name) Set"
            }
        case .pokedexNumber(let pokedexNumber):
            return "Pokedex #\(pokedexNumber)"
        }
    }
    
    var navigationSubTitle: String {
        let baseSubTitle = "\(refinedCards.count) \(allCards.count != refinedCards.count ? "filtered " : "")"
        switch configuration {
        case .set, .pokedexNumber:
            return baseSubTitle + "cards to collect"
        }
    }
    
    var allImageURLStrings: [String] {
        return refinedCards.compactMap { card in
            card.images.large
        }
    }
    
    init(set: PokemonTCGSet) {
        configuration = .set(set)
        refinement = CardsRefinement(initialSort: CardsRefinement.Sort(property: .setNumber, order: .forward))
        shouldShowPokedexButton = true
        shouldShowSetButton = false
    }
    
    init(pokedexNumber: Int) {
        configuration = .pokedexNumber(pokedexNumber)
        refinement = CardsRefinement(initialSort: CardsRefinement.Sort(property: .releaseDate, order: .forward))
        shouldShowPokedexButton = false
        shouldShowSetButton = true
    }
    
    @MainActor func fetchCards(with settings: PokevSettings) async {
        isFetchingCards = true
        do {
            let service = PokemonTCGAPIService()
            switch configuration {
            case .set(let set):
                allCards = try await service.getCards(with: set.id, settings: settings)
            case .pokedexNumber(let pokedexNumber):
                allCards = try await service.getCards(with: pokedexNumber, settings: settings)
            }
            refinement = CardsRefinement(initialSort: refinement.initialSort, allRaritiesInSet: allCards.allRarities)
            refineCards(with: settings)
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
        }
        isFetchingCards = false
    }
    
    func refineCards(with settings: PokevSettings) {
        let filteredCards = allCards.filter { card in
            if refinement.filters.onlyPotentialDeals {
                if !card.isPotentialDeal {
                    return false
                }
            }
            
            if refinement.filters.rarities != refinement.filters.allRaritiesInSet {
                if let rarity = card.rarity {
                    if !refinement.filters.rarities.contains(rarity) {
                        return false
                    }
                } else {
                    return false
                }
            }
            
            switch configuration {
            case .set, .pokedexNumber:
                if settings.onlyGenerationOne {
                    return card.nationalPokedexNumbers?.allSatisfy({ $0 >= 1 && $0 <= 151 }) ?? false
                }
                return true
            }
        }
        
        let sortedFilteredCards = filteredCards.sorted { card1, card2 in
            switch refinement.currentSort.property {
            case .alphabetical:
                return refinement.currentSort.order == .forward ? card1.name < card2.name : card1.name > card2.name
            case .setNumber:
                return card1.number.localizedStandardCompare(card2.number) == (refinement.currentSort.order == .forward ? .orderedAscending : .orderedDescending)
            case .pokedexNumber:
                // In almost all cases, there will only be one pokedex number. When there are multiple, just grab the first.
                if let card1FirstPokedexNumber = card1.nationalPokedexNumbers?.first {
                    if let card2FirstPokedexNumber = card2.nationalPokedexNumbers?.first {
                        return refinement.currentSort.order == .forward ? card1FirstPokedexNumber < card2FirstPokedexNumber : card1FirstPokedexNumber > card2FirstPokedexNumber
                    } else {
                        return refinement.currentSort.order == .forward
                    }
                } else {
                    return refinement.currentSort.order == .forward
                }
            case .releaseDate:
                let apiDateFormatter = DateFormatter()
                apiDateFormatter.dateFormat = "yyyy/MM/dd"
                
                if let card1ReleaseDate = apiDateFormatter.date(from: card1.set.releaseDate) {
                    if let card2ReleaseDate = apiDateFormatter.date(from: card2.set.releaseDate) {
                        return refinement.currentSort.order == .forward ? card1ReleaseDate < card2ReleaseDate : card1ReleaseDate > card2ReleaseDate
                    } else {
                        return refinement.currentSort.order == .forward
                    }
                } else {
                    return refinement.currentSort.order == .forward
                }
            }
        }
                
        refinedCards = sortedFilteredCards
        
        shouldShowNoResultsScreen = !allCards.isEmpty && refinedCards.isEmpty
    }
    
    func searchCards() {
        if searchText.isEmpty {
            cardsToDisplay = refinedCards
        } else {
            cardsToDisplay = refinedCards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct CardsRefinement: Equatable {
    struct Sort: Equatable {
        enum Property {
            case alphabetical
            case setNumber
            case pokedexNumber
            case releaseDate
        }
        
        var property: Property
        var order: SortOrder
    }
    
    struct Filters: Equatable {
        var onlyPotentialDeals: Bool
        var rarities: Set<String>
        var allRaritiesInSet: Set<String>
        
        var onlyShowCertainRarities: Bool {
            return rarities != allRaritiesInSet
        }
        
        var isDefault: Bool {
            return !onlyPotentialDeals && rarities == allRaritiesInSet
        }
        
        init(onlyPotentialDeals: Bool = false, rarities: Set<String>? = nil, allRaritiesInSet: Set<String>) {
            self.onlyPotentialDeals = onlyPotentialDeals
            self.rarities = rarities ?? allRaritiesInSet
            self.allRaritiesInSet = allRaritiesInSet
        }
    }
    
    let initialSort: Sort
    var currentSort: Sort
    var filters: Filters
    
    var isDefault: Bool {
        return currentSort == initialSort && filters.isDefault
    }
    
    init(initialSort: Sort, filters: Filters? = nil, allRaritiesInSet: Set<String> = Set<String>()) {
        self.initialSort = initialSort
        self.currentSort = initialSort
        self.filters = filters ?? Filters(allRaritiesInSet: allRaritiesInSet)
    }
    
    static func == (lhs: CardsRefinement, rhs: CardsRefinement) -> Bool {
        return lhs.filters == rhs.filters && lhs.currentSort == rhs.currentSort && lhs.initialSort == rhs.initialSort
    }
    
    mutating func reset() {
        currentSort = initialSort
        filters = Filters(allRaritiesInSet: filters.allRaritiesInSet)
    }
}

extension [PokemonTCGCard] {
    var allRarities: Set<String> {
        Set(compactMap { $0.rarity })
    }
}
