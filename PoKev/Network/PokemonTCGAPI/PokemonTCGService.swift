//
//  PokemonTCGService.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

import Foundation

protocol PokemonTCGServiceable {
    func getSets(forMode mode: Settings.Mode) async throws -> [PokemonTCGSet]
    func getCards(forSet setId: String, forMode mode: Settings.Mode) async throws -> [PokemonTCGCard]
    func getCards(forPokedexNumber pokedexNumber: Int, forMode mode: Settings.Mode) async throws -> [PokemonTCGCard]
}

struct PokemonTCGService: HTTPClient, PokemonTCGServiceable {
    func getSets(forMode mode: Settings.Mode) async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets(mode: mode), responseModel: PokemonTCGSetsResponse.self).sets
    }
    
    func getCards(forSet setId: String, forMode mode: Settings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsBySetId(setId, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(forPokedexNumber pokedexNumber: Int, forMode mode: Settings.Mode) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByPokedexNumber(pokedexNumber, mode: mode), responseModel: PokemonTCGCardsResponse.self).cards
    }
}
