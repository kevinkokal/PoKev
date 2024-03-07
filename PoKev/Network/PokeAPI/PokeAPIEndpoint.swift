//
//  PokeAPIEndpoint.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

protocol PokeAPIEndpoint: Endpoint { }

extension PokeAPIEndpoint {
    var host: String {
        return "pokeapi.co"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var body: [String: String]? {
        return nil
    }
    
    var header: [String: String]? {
        return [:]
    }
}
