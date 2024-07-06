//
//  CardsEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

enum CardsEndpoint {
    case cardsBySetId(_ setId: String, mode: PokevSettings.Mode)
    case cardsByPokedexNumber(_ pokedexNumber: Int, mode: PokevSettings.Mode)
    case cardsByIds(_ ids: [String])
}

extension CardsEndpoint: PokemonTCGEndpoint {
    var path: String {
        switch self {
        case .cardsBySetId, .cardsByPokedexNumber, .cardsByIds:
            return "/v2/cards"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var searchQuery: String?
        var queryItems: [URLQueryItem]
        
        switch self {
        case .cardsBySetId(let setId, let mode):
            switch mode {
            case .unrestricted:
                searchQuery = "set.id:\(setId)"
            case .alana:
                searchQuery = "-rarity:Common -rarity:Uncommon set.id:\(setId)"
            case .kevin:
                searchQuery = "set.id:\(setId) nationalPokedexNumbers:[1 TO 151]"
            }
            
            queryItems = [
                URLQueryItem(name: "orderBy", value: "number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
        case .cardsByPokedexNumber(let pokedexNumber, let mode):
            switch mode {
            case .unrestricted:
                searchQuery = "nationalPokedexNumbers:\(pokedexNumber)"
            case .alana:
                searchQuery = "nationalPokedexNumbers:\(pokedexNumber) -rarity:Common -rarity:Uncommon -set.series:Other -set.series:NP -series:POP -set.name:\"EX Trainer Kit\" -set.name:\"Kalos Starter Set\" -set.name:\"Scarlet %26 Violet Energies\" -set.name:\"Celebrations: Classic Collection\" -set.name:\"Legendary Collection\" -set.name:\"Emerging Powers\" -set.name:\"Base Set 2\""
            case .kevin:
                searchQuery = "nationalPokedexNumbers:\(pokedexNumber) -set.series:Other -set.series:NP -series:POP -set.name:\"Black Star Promos\" -set.name:\"EX Trainer Kit\" -set.name:\"Kalos Starter Set\" -set.name:\"Scarlet %26 Violet Energies\" -set.name:\"Celebrations: Classic Collection\" -set.name:\"Legendary Collection\" -set.name:\"Emerging Powers\" -set.name:\"Base Set 2\""
            }
            
            queryItems = [
                URLQueryItem(name: "orderBy", value: "set.releaseDate,number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
            
        case .cardsByIds(let ids):
            searchQuery = "(\(ids.map { "id:\($0)" }.joined(separator: " OR ")))"
            
            queryItems = [
                URLQueryItem(name: "orderBy", value: "set.releaseDate,number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
        }
        
        if let searchQuery = searchQuery {
            queryItems.append(URLQueryItem(name: "q", value: searchQuery))
        }
        
        return queryItems
    }
}
