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

    init(card: PokemonTCGCard) {
        self.card = card
    }
}
