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
    let set: PokemonTCGSet
    
    private(set) var allCards = [PokemonTCGCard]()
    private(set) var refinedCards = [PokemonTCGCard]()
    var isFetchingCards = false
    
    private(set) var error: RequestError?
    var shouldPresentError = false
    
    var cardDetailIsPresented = false
    var selectedCard: PokemonTCGCard?
    
    var refinementMenuIsPresented = false
    var refinement = CardsRefinement() {
        didSet {
            refineCards()
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
        return "\(set.name) Set"
    }
    
    var navigationSubTitle: String {
        return "\(refinedCards.count) \(allCards.count != refinedCards.count ? "filtered " : "")cards to collect"
    }
    
    init(set: PokemonTCGSet) {
        self.set = set
    }
    
    func fetchCards() async {
        isFetchingCards = true
        do {
            allCards = try await PokemonTCGService().getCards(forSet: set.id)
            isFetchingCards = false
            refinement = CardsRefinement(allRaritiesInSet: allCards.allRarities)
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingCards = false
        }
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
            switch refinement.sortOrder {
            case .alphabetical:
                return card1.name < card2.name
            case .setNumber:
                return card1.number < card2.number
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
    
    var sortOrder: SortOrder
    var filters: Filters
    
    var isDefault: Bool {
        return sortOrder == .setNumber && filters.isDefault
    }
    
    init(sortOrder: SortOrder = .setNumber, filters: Filters? = nil, allRaritiesInSet: Set<String> = Set<String>()) {
        self.sortOrder = sortOrder
        self.filters = filters ?? Filters(allRaritiesInSet: allRaritiesInSet)
    }
}

extension [PokemonTCGCard] {
    var allRarities: Set<String> {
        Set(map { $0.rarity })
    }
}


