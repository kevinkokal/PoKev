//
//  PokemonsMetadataResponse.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

struct PokemonsMetadataResponse: Decodable {
    let pokemonsMetadata: [PokemonMetadata]
    
    struct PokemonMetadata: Decodable, Identifiable {
        var id: String {
            name + url
        }
        
        let name: String
        private let url: String
        var pokedexNumber: Int? {
            if let lastMatch = url.matches(for: "(\\d+)(?!.*\\d)").last {
                return Int(lastMatch)
            }
            return nil
        }
    }
}
