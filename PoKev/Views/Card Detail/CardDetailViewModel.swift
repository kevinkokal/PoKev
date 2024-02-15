//
//  CardDetailViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 2/14/24.
//

import Foundation

final class CardDetailViewModel {
    let card: PokemonTCGCard

    var imageURL: URL? {
        if let urlString = card.images.large {
            return URL(string: urlString)
        }
        return nil
    }
    
    var tcgPlayerURL: URL? {
        if let urlString = card.tcgplayer?.url {
            return URL(string: urlString)
        }
        return nil
    }
    
    var cardTitle: String {
        return card.name
    }
    
    init(card: PokemonTCGCard) {
        self.card = card
    }
}
