//
//  PokemonListViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import Observation

@Observable
final class PokemonListViewModel {
    private(set) var allPokemon = [PokemonResponse.Pokemon]() {
        didSet {
            pokemonToDisplay = allPokemon
        }
    }
    private(set) var pokemonToDisplay = [PokemonResponse.Pokemon]()
    private(set) var error: RequestError?
    var shouldPresentError = false
    var isFetchingPokemon = false
    
    var searchText = "" {
        didSet {
            filterPokemon()
        }
    }
    
    var errorMessage: String {
        if let error = self.error {
            return "\(error.customMessage)"
        } else {
            return "Unknown error"
        }
    }

    @MainActor
    func fetchPokemon(mode: Settings.Mode) async {
        isFetchingPokemon = true
        do {
            allPokemon = try await PokeAPIService().getPokemon(mode: mode)
            isFetchingPokemon = false
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingPokemon = false
        }
    }
    
    func filterPokemon() {
        if searchText.isEmpty {
            pokemonToDisplay = allPokemon
        } else {
            pokemonToDisplay = allPokemon.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
