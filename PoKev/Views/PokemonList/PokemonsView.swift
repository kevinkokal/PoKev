//
//  PokemonsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import SwiftUI

struct PokemonsView: View {
    @State private var viewModel = PokemonListViewModel()
    @Environment(PokevSettings.self) var settings
    
    var body: some View {
        ScrollView() {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.pokemonToDisplay) { pokemon in
                    Group {
                        if let pokedexNumber = pokemon.pokedexNumber {
                            NavigationLink {
                                CardsView(pokedexNumber: pokedexNumber)
                            } label: {
                                PokemonView(name: pokemon.name, number: pokedexNumber)
                            }
                            
                        } else {
                            Button {
                                viewModel.shouldPresentError = true
                            } label: {
                                PokemonView(name: pokemon.name, number: -1)
                            }

                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.leading, .trailing], 8)
        }
        .task {
            if viewModel.allPokemon.isEmpty {
                await viewModel.fetchPokemon(mode: settings.mode)
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
        .navigationTitle("Pokemon")
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    PokemonsView()
}
