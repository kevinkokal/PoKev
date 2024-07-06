//
//  PokemonViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

final class PokemonViewModel {
    let name: String
    let numberToDisplay: String
    let imageURLString: String

    init(name: String, number: Int) {
        self.name = name
        self.numberToDisplay = number > 0 ? "\(number)" : "N/A"
        self.imageURLString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png"
    }
}
