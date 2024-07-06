//
//  CardsEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

enum CardsEndpoint {
    case cardsBySetId(_ setId: String, settings: PokevSettings)
    case cardsByPokedexNumber(_ pokedexNumber: Int, settings: PokevSettings)
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
        var searchQuery: String
        var queryItems: [URLQueryItem]
        
        switch self {
        case .cardsBySetId(let setId, let settings):
            searchQuery = "set.id:\(setId)"
            
            if !settings.includeCommonsAndUncommons {
                searchQuery += " -rarity:Common -rarity:Uncommon"
            }
            
            if settings.onlyGenerationOne {
                searchQuery += " nationalPokedexNumbers:[1 TO 151]"
            }
            
            queryItems = [
                URLQueryItem(name: "orderBy", value: "number"),
                URLQueryItem(name: "select", value: "id,name,set,number,images,tcgplayer,nationalPokedexNumbers,rarity")
            ]
        case .cardsByPokedexNumber(let pokedexNumber, let settings):
            searchQuery = "nationalPokedexNumbers:\(pokedexNumber)"
            
            if settings.onlyStandardSets {
                searchQuery += " -set.series:Other -set.series:NP -series:POP -set.name:\"EX Trainer Kit\" -set.name:\"Kalos Starter Set\" -set.name:\"Scarlet %26 Violet Energies\" -set.name:\"Celebrations: Classic Collection\" -set.name:\"Legendary Collection\" -set.name:\"Emerging Powers\" -set.name:\"Base Set 2\""
            }
            
            if !settings.includeCommonsAndUncommons {
                searchQuery += " -rarity:Common -rarity:Uncommon"
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
        
        queryItems.append(URLQueryItem(name: "q", value: searchQuery))
        return queryItems
    }
}
