//
//  PokemonTCGSetsResponse.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import Foundation

struct PokemonTCGSetsResponse: Decodable {
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int
    let sets: [PokemonTCGSet]

    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case count
        case totalCount
        case sets = "data"
    }
}
