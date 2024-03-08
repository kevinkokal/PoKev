//
//  PokemonTCGAPIService.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

// API Docs: https://docs.pokemontcg.io/

import Foundation

protocol PokemonTCGAPIServiceable {
    func getSets(for mode: PokevSettings.Mode) async throws -> [PokemonTCGSet]
    func getCards(for setId: String, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard]
    func getCards(for pokedexNumber: Int, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard]
}

struct PokemonTCGAPIService: HTTPClient, PokemonTCGAPIServiceable {
    func getSets(for mode: PokevSettings.Mode) async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets(mode: mode), responseModel: PokemonTCGSetsResponse.self).sets
    }
    
    func getCards(for setId: String, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsBySetId(setId, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(for pokedexNumber: Int, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByPokedexNumber(pokedexNumber, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
}
