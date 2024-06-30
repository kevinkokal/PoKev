//
//  PokemonsMetadataResponse.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

struct PokemonsMetadataResponse: Decodable {
    let pokemonsMetadata: [PokemonMetadata]
    
    enum CodingKeys: String, CodingKey {
        case pokemonsMetadata = "results"
    }
    
    struct PokemonMetadata: Decodable, Identifiable {
        let name: String
        private let url: String
        
        var id: String {
            name + url
        }
        
        var pokedexNumber: Int? {
            if let lastMatch = url.matches(for: "(\\d+)(?!.*\\d)").last {
                return Int(lastMatch)
            }
            return nil
        }
    }
}
