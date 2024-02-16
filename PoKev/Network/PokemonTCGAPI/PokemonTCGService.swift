//
//  PokemonTCGService.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

import Foundation

protocol PokemonTCGServiceable {
    func getSets() async throws -> [PokemonTCGSet]
    func getCards(forSet setId: String) async throws -> [PokemonTCGCard]
    func getCards(forPokedexNumber pokedexNumber: Int) async throws -> [PokemonTCGCard]
}

struct PokemonTCGService: HTTPClient, PokemonTCGServiceable {
    func getSets() async throws -> [PokemonTCGSet] {
        return try await sendRequest(endpoint: SetsEndpoint.sets, responseModel: PokemonTCGSetsResponse.self).sets
    }
    
    func getCards(forSet setId: String) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsBySetId(setId), responseModel: PokemonTCGCardsResponse.self).cards
    }
    
    func getCards(forPokedexNumber pokedexNumber: Int) async throws -> [PokemonTCGCard] {
        return try await sendRequest(endpoint: CardsEndpoint.cardsByPokedexNumber(pokedexNumber), responseModel: PokemonTCGCardsResponse.self).cards
    }
}
