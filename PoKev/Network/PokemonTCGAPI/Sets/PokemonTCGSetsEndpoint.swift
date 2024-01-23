//
//  SetsEndpoint.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

import Foundation

enum SetsEndpoint {
    case sets
}

extension SetsEndpoint: PokemonTCGEndpoint {
    var path: String {
        switch self {
        case .sets:
            return "/v2/sets"
        }
    }

    var method: RequestMethod {
        switch self {
        case .sets:
            return .get
        }
    }

    var header: [String: String]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
            else { fatalError("API_KEY missing in Info.plist / Info.plist missing") }
        switch self {
        case .sets:
            return [
                "X-Api-Key": apiKey
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .sets:
            return nil
        }
    }
}
