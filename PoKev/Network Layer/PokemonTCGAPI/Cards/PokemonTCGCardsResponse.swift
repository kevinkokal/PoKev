//
//  PokemonTCGCardsResponse.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

struct PokemonTCGCardsResponse: Decodable {
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int
    let cards: [PokemonTCGCard]

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case count
        case totalCount
        case cards = "data"
    }
}
