//
//  PokemonEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

enum PokemonEndpoint {
    case names(settings: PoKevSettings)
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
        case .names(let settings):
            queryItems = [
                URLQueryItem(name: "limit", value: settings.onlyGenerationOne ? "151" : "1025")
            ]
        }
        
        return queryItems
    }
}
