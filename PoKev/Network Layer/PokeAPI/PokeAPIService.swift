//
//  PokeAPIService.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

// API Docs: https://pokeapi.co/docs/v2

import Foundation

protocol PokeAPIServiceable {
    func getPokemonsMetadata(with settings: PokevSettings) async throws -> [PokemonsMetadataResponse.PokemonMetadata]
}

struct PokeAPIService: HTTPClient, PokeAPIServiceable {
    func getPokemonsMetadata(with settings: PokevSettings) async throws -> [PokemonsMetadataResponse.PokemonMetadata] {
        return try await sendRequest(endpoint: PokemonEndpoint.names(settings: settings), responseModel: PokemonsMetadataResponse.self).pokemonsMetadata
    }
}
