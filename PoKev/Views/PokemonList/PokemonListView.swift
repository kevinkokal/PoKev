//
//  PokemonListView.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import SwiftUI

struct PokemonListView: View {
    @State private var viewModel = PokemonListViewModel()
    @Environment(Settings.self) var settings
    
    var body: some View {
        ScrollView() {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.pokemonToDisplay) { pokemon in
                    Group {
                        if let pokedexNumber = pokemon.number {
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
        .navigationBarTitleDisplayMode(.automatic)
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    PokemonListView()
}
