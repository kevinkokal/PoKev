//
//  PokemonTCGEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import Foundation

protocol PokemonTCGEndpoint: Endpoint { }

extension PokemonTCGEndpoint {
    var host: String {
        return "api.pokemontcg.io"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var body: [String: String]? {
        return nil
    }
    
    var header: [String: String]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Api key") as? String
            else { fatalError("Api key missing in Info.plist / Info.plist missing") }

        return [
            "X-Api-Key": apiKey
        ]
    }
}
