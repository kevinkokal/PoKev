//
//  PokeAPIService.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Foundation

protocol PokeServiceable {
    func getPokemon(mode: Settings.Mode) async throws -> [PokemonResponse.Pokemon]
}

struct PokeAPIService: HTTPClient, PokeServiceable {
    func getPokemon(mode: Settings.Mode) async throws -> [PokemonResponse.Pokemon] {
        return try await sendRequest(endpoint: PokemonEndpoint.names(mode: mode), responseModel: PokemonResponse.self).results
    }
}
