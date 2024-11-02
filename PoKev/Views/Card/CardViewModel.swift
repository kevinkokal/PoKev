//
//  CardViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class CardViewModel {
    let card: PokemonTCGCard
    let set: PokemonTCGSet
    let shouldShowPokedexButton: Bool
    let shouldShowSetButton: Bool

    var imageURL: URL? {
        if let urlString = card.images.small {
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
    
    var cardSubtitle: String {
       return "(\(card.number)/\(set.printedTotal))"
    }
    
    var highlightColor: Color? {
        let highlightColor = Color("HighlightedCard")
        
        return card.isPotentialDeal ? highlightColor : nil
    }
    
    let selectPokedexNumberMessage = "Select Pokedex Number"
    
    init(card: PokemonTCGCard, set: PokemonTCGSet, shouldShowPokedexButton: Bool, shouldShowSetButton: Bool) {
        self.card = card
        self.set = set
        self.shouldShowPokedexButton = shouldShowPokedexButton
        self.shouldShowSetButton = shouldShowSetButton
    }
}
