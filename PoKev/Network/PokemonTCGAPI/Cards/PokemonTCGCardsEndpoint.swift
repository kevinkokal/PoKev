//
//  PokemonTCGCardsEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

enum CardsEndpoint {
    case cardsBySetId(_ setId: String)
    case cardsByPokedexNumber(_ pokedexNumber: Int)
}

extension CardsEndpoint: PokemonTCGEndpoint {
    var path: String {
        switch self {
        case .cardsBySetId, .cardsByPokedexNumber:
            return "/v2/cards"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .cardsBySetId(let setId):
            return [
                URLQueryItem(name: "q", value: "set.id:\(setId) nationalPokedexNumbers:[1 TO 151]"),
                URLQueryItem(name: "orderBy", value: "number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
        case .cardsByPokedexNumber(let pokedexNumber):
            return [
                URLQueryItem(name: "q", value: "nationalPokedexNumbers:\(pokedexNumber) -set.series:Other -set.series:NP -series:POP -set.name:\"Black Star Promos\" -set.name:\"EX Trainer Kit\" -set.name:\"Kalos Starter Set\" -set.name:\"Scarlet %26 Violet Energies\" -set.name:\"Celebrations: Classic Collection\" -set.name:\"Legendary Collection\" -set.name:\"Emerging Powers\" -set.name:\"Base Set 2\""),
                URLQueryItem(name: "orderBy", value: "set.releaseDate,number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
        }
    }
}
