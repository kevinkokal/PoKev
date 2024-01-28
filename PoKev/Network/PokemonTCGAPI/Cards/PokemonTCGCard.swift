//
//  PokemonTCGCard.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

struct PokemonTCGCardImages: Decodable {
    let small: String?
    let large: String?
}

struct PokemonTCGCard: Decodable, Identifiable {
    let id: String
    let name: String
    let number: String
    let images: PokemonTCGCardImages
    let tcgplayer: PokemonTCGPlayerData?
}
