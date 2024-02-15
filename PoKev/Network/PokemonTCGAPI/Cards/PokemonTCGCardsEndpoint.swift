//
//  PokemonTCGCardsEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

enum CardsEndpoint {
    case cardsBySetId(_ setId: String)
}

extension CardsEndpoint: PokemonTCGEndpoint {
    var path: String {
        switch self {
        case .cardsBySetId:
            return "/v2/cards"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .cardsBySetId(let setId):
            return [
                URLQueryItem(name: "q", value: "set.id:\(setId) nationalPokedexNumbers:[1 TO 151]"),
                URLQueryItem(name: "orderBy", value: "number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers")
            ]
        }
    }
}
