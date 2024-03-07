//
//  PokemonResponse.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

struct PokemonResponse: Decodable {
    let results: [Pokemon]
    
    struct Pokemon: Decodable, Identifiable {
        var id: String {
            name + url
        }
        
        let name: String
        private let url: String
        var number: Int? {
            if let lastMatch = url.matches(for: "(\\d+)(?!.*\\d)").last {
                return Int(lastMatch)
            }
            return nil
        }
    }
}
