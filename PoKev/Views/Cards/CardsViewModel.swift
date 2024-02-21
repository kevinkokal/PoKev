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
    private(set) var refinedCards = [PokemonTCGCard]()
    var isFetchingCards = false
    let shouldShowPokedexButton: Bool
    
    private(set) var error: RequestError?
    var shouldPresentError = false
    
    var cardDetailIsPresented = false
    var selectedCard: PokemonTCGCard?
    
    var refinementMenuIsPresented = false
    var refinement: CardsRefinement
    
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
            return "Pokedex: \(pokedexNumber)"
        }
    }
    
    var navigationSubTitle: String {
        return "\(refinedCards.count) \(allCards.count != refinedCards.count ? "filtered " : "")cards to collect"
    }
    
    init(set: PokemonTCGSet) {
        configuration = .set(set)
        refinement = CardsRefinement(initialSortOrder: .setNumber)
        shouldShowPokedexButton = true
    }
    
    init(pokedexNumber: Int) {
        configuration = .pokedexNumber(pokedexNumber)
        refinement = CardsRefinement(initialSortOrder: .releaseDate)
        shouldShowPokedexButton = false
    }
    
    @MainActor func fetchCards() async {
        isFetchingCards = true
        do {
            let service = PokemonTCGService()
            switch configuration {
            case .set(let set):
                allCards = try await service.getCards(forSet: set.id)
            case .pokedexNumber(let pokedexNumber):
                allCards = try await service.getCards(forPokedexNumber: pokedexNumber)
            }
            
            let initialSortOrder: CardsRefinement.SortOrder
            switch configuration {
            case .set:
                initialSortOrder = .setNumber
            case .pokedexNumber:
                initialSortOrder = .releaseDate
            }
            refinement = CardsRefinement(initialSortOrder: initialSortOrder, allRaritiesInSet: allCards.allRarities)
            refineCards()
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
        }
        isFetchingCards = false
    }
    
    private func refineCards() {
        let filteredCards = allCards.filter { card in
            if refinement.filters.onlyPotentialDeals {
                if !card.isPotentialDeal {
                    return false
                }
            }
            
            if refinement.filters.rarities != refinement.filters.allRaritiesInSet {
                if !refinement.filters.rarities.contains(card.rarity) {
                    return false
                }
            }
            
            return true
        }
        
        let sortedFilteredCards = filteredCards.sorted { card1, card2 in
            switch refinement.currentSortOrder {
            case .alphabetical:
                return card1.name < card2.name
            case .setNumber:
                return card1.number.localizedStandardCompare(card2.number) == .orderedAscending
            case .pokedexNumber:
                // In almost all cases, there will only be one pokedex number. When there are multiple, just grab the first.
                if let card1FirstPokedexNumber = card1.nationalPokedexNumbers.first {
                    if let card2FirstPokedexNumber = card2.nationalPokedexNumbers.first {
                        return card1FirstPokedexNumber < card2FirstPokedexNumber
                    } else {
                        return true
                    }
                } else {
                    return card2.nationalPokedexNumbers.first == nil
                }
            case .releaseDate:
                let apiDateFormatter = DateFormatter()
                apiDateFormatter.dateFormat = "yyyy/MM/dd"
                
                if let card1ReleaseDate = apiDateFormatter.date(from: card1.set.releaseDate) {
                    if let card2ReleaseDate = apiDateFormatter.date(from: card2.set.releaseDate) {
                        return card1ReleaseDate < card2ReleaseDate
                    } else {
                        return true
                    }
                } else {
                    return apiDateFormatter.date(from: card2.set.releaseDate) == nil
                }
            }
        }
                
        refinedCards = sortedFilteredCards
    }
}

struct CardsRefinement {
    enum SortOrder {
        case alphabetical
        case setNumber
        case pokedexNumber
        case releaseDate
    }
    
    struct Filters {
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
    
    let initialSortOrder: SortOrder
    var currentSortOrder: SortOrder
    var filters: Filters
    
    var isDefault: Bool {
        return currentSortOrder == initialSortOrder && filters.isDefault
    }
    
    init(initialSortOrder: SortOrder, filters: Filters? = nil, allRaritiesInSet: Set<String> = Set<String>()) {
        self.initialSortOrder = initialSortOrder
        self.currentSortOrder = initialSortOrder
        self.filters = filters ?? Filters(allRaritiesInSet: allRaritiesInSet)
    }
    
    mutating func reset() {
        currentSortOrder = initialSortOrder
        filters = Filters(allRaritiesInSet: filters.allRaritiesInSet)
    }
}

extension [PokemonTCGCard] {
    var allRarities: Set<String> {
        Set(map { $0.rarity })
    }
}


