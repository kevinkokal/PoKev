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
    private(set) var error: RequestError?
    var shouldPresentError = false
    var isFetchingCards = false
    var cardDetailIsPresented = false
    var selectedCard: PokemonTCGCard?
    
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
        //TODO: Added is empty check to prevent spinner showing up when it shouldn't...
        if cards.isEmpty {
            isFetchingCards = true
        }
        do {
            cards = try await PokemonTCGService().getCards(forSet: set.id)
            isFetchingCards = false
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingCards = false
        }
    }
}
