//
//  PokemonSet.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import Foundation

struct PokemonTCGSetImages: Decodable {
    let symbol: String
    let logo: String
}

struct PokemonTCGSet: Decodable, Identifiable {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let releaseDate: String
    let images: PokemonTCGSetImages
}
