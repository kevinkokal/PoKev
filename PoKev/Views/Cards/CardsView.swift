//
//  CardsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import SwiftUI

struct CardsView: View {
    @State var viewModel: CardsViewModel
    
    private var gridItemLayout =  [GridItem(.flexible()), GridItem(.flexible())]
    
    init(set: PokemonTCGSet) {
        viewModel = CardsViewModel(set: set)
    }
    
    var body: some View {
        Group {
            if viewModel.isFetchingCards {
                PokeBallProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridItemLayout, spacing: 16) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card, set: viewModel.set).onTapGesture {
                                viewModel.cardDetailIsPresented = true
                                viewModel.selectedCard = card
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .task {
            if viewModel.cards.isEmpty {
                await viewModel.fetchCards()
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.navigationTitle).font(.headline)
                    if !viewModel.cards.isEmpty {
                        Text("\(viewModel.cards.count) to collect").font(.subheadline)
                    }
                }
            }
            ToolbarItem {
                Button(action: {
                    viewModel.refinementMenuIsPresented = true
                }) {
                    if viewModel.refinement.isDefault {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.cardDetailIsPresented) {
            if let selectedCard = viewModel.selectedCard {
                CardDetailView(viewModel: CardDetailViewModel(card: selectedCard))
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $viewModel.refinementMenuIsPresented) {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Sort Order", selection: $viewModel.refinement.sortOrder) {
                        Text("Alphabetical").tag(CardsRefinement.SortOrder.alphabetical)
                        Text("Number in Set").tag(CardsRefinement.SortOrder.setNumber)
                        Text("Number in Pokedex").tag(CardsRefinement.SortOrder.pokedexNumber)
                    }
                }
                Section(header: Text("Filters")) {
                    Toggle("Only show potential deals", isOn: $viewModel.refinement.filters.onlyPotentialDeals)
                }
            }
        }
    }
}

#Preview {
    CardsView(set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}

