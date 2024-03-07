//
//  PokemonEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

enum PokemonEndpoint {
    case names(mode: Settings.Mode)
}

extension PokemonEndpoint: PokeAPIEndpoint {
    var path: String {
        switch self {
        case .names:
            return "/api/v2/pokemon"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var queryItems: [URLQueryItem]
        
        switch self {
        case .names(let mode):
            queryItems = [
                URLQueryItem(name: "limit", value: mode == .kevin ? "151" : "1025")
            ]
        }
        
        return queryItems
    }
}
