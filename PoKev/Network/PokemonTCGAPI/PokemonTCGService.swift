//
//  PokemonTCGService.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

import Foundation

protocol PokemonTCGServiceable {
    func getSets() async throws -> [PokemonTCGSet]
}

struct PokemonTCGService: HTTPClient, PokemonTCGServiceable {
    func getSets() async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets, responseModel: PokemonTCGSetsResponse.self).sets
    }
}
