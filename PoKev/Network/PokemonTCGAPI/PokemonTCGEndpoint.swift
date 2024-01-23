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
}
