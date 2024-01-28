//
//  CardViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import Foundation
import Observation

@Observable
final class CardViewModel {
    @ObservationIgnored let card: PokemonTCGCard
    @ObservationIgnored let set: PokemonTCGSet

    var largeImageURL: URL? {
        if let urlString = card.images.large {
            return URL(string: urlString)
        }
        return nil
    }
    
    var cardTitle: String {
        return card.name
    }
    
    var cardSubtitle: String {
       return "(\(card.number)/\(set.printedTotal))"
    }
    
    init(card: PokemonTCGCard, set: PokemonTCGSet) {
        self.card = card
        self.set = set
    }
}
