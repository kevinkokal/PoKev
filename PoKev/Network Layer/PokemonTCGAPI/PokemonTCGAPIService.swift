//
//  PokemonTCGAPIService.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

// API Docs: https://docs.pokemontcg.io/

import Foundation

protocol PokemonTCGAPIServiceable {
    func getSets(with settings: PokevSettings) async throws -> [PokemonTCGSet]
    func getCards(with setId: String, settings: PokevSettings) async throws -> [PokemonTCGCard]
    func getCards(with pokedexNumber: Int, settings: PokevSettings) async throws -> [PokemonTCGCard]
    func getCards(with ids: [String]) async throws -> [PokemonTCGCard]
}

struct PokemonTCGAPIService: HTTPClient, PokemonTCGAPIServiceable {
    func getSets(with settings: PokevSettings) async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets(settings: settings), responseModel: PokemonTCGSetsResponse.self).sets
    }
    
    func getCards(with setId: String, settings: PokevSettings) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsBySetId(setId, settings: settings), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(with pokedexNumber: Int, settings: PokevSettings) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByPokedexNumber(pokedexNumber, settings: settings), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(with ids: [String]) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByIds(ids), responseModel: PokemonTCGCardsResponse.self).cards
    }
}
