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
    func getCards(with setId: String, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard]
    func getCards(with pokedexNumber: Int, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard]
    func getCards(with ids: [String]) async throws -> [PokemonTCGCard]
}

struct PokemonTCGAPIService: HTTPClient, PokemonTCGAPIServiceable {
    func getSets(for mode: PokevSettings.Mode) async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets(mode: mode), responseModel: PokemonTCGSetsResponse.self).sets
    }
    
    func getCards(with setId: String, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsBySetId(setId, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(with pokedexNumber: Int, mode: PokevSettings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByPokedexNumber(pokedexNumber, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(with ids: [String]) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByIds(ids), responseModel: PokemonTCGCardsResponse.self).cards
    }
}
