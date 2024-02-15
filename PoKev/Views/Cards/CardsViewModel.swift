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
    
    private(set) var cards = [PokemonTCGCard]()
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
        return "\(cards.count) cards to collect"
    }
    
    init(set: PokemonTCGSet) {
        self.set = set
    }
    
    func fetchCards() async {
        isFetchingCards = true
        do {
            cards = try await PokemonTCGService().getCards(forSet: set.id)
            isFetchingCards = false
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingCards = false
        }
    }
    
    private func refineCards() {
        let filteredCards = cards.filter { card in
            if refinement.filters.onlyPotentialDeals {
                return card.isPotentialDeal
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
        
        cards = sortedFilteredCards
    }
}

struct CardsRefinement {
    enum SortOrder {
        case alphabetical
        case setNumber
        case pokedexNumber
    }
    
    struct Filters {
        var onlyPotentialDeals = false
        
        var isDefault: Bool {
            return !onlyPotentialDeals
        }
    }
    
    var sortOrder: SortOrder = .setNumber
    var filters = Filters()
    
    var isDefault: Bool {
        return sortOrder == .setNumber && filters.isDefault
    }
}


