//
//  CardsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import MultiPicker
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
                        ForEach(viewModel.refinedCards) { card in
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
            if viewModel.allCards.isEmpty {
                await viewModel.fetchCards()
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.navigationTitle).font(.headline)
                    if !viewModel.refinedCards.isEmpty {
                        Text(viewModel.navigationSubTitle).font(.subheadline)
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
                .disabled(viewModel.isFetchingCards)
                .sheet(isPresented: $viewModel.refinementMenuIsPresented) {
                    RefinementForm(refinementModel: $viewModel.refinement)
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
    }
    
    enum ActiveSheet {
       case first, second
       var id: Int {
          hashValue
       }
    }
}

struct RefinementForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var refinement: CardsRefinement
    
    init(refinementModel: Binding<CardsRefinement>) {
        _refinement = refinementModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Sort Order", selection: $refinement.sortOrder) {
                        Text("Alphabetical").tag(CardsRefinement.SortOrder.alphabetical)
                        Text("Number in Set").tag(CardsRefinement.SortOrder.setNumber)
                        Text("Number in Pokedex").tag(CardsRefinement.SortOrder.pokedexNumber)
                    }
                }
                Section(header: Text("Price Filters")) {
                    Toggle("Only show potential deals", isOn: $refinement.filters.onlyPotentialDeals)
                }
                Section(header: Text("Rarity Filters")) {
                    MultiPicker("Only show certain rarities", selection: $refinement.filters.rarities) {
                        ForEach(Array(refinement.filters.allRaritiesInSet), id:\.self) { rarity in
                            Text(rarity).mpTag(rarity)
                        }
                    }
                }
            }
            .navigationBarItems(leading: Button("Reset", action: { refinement = CardsRefinement(allRaritiesInSet: refinement.filters.allRaritiesInSet) }), trailing: Button("Done", action: { dismiss() }))
            .navigationTitle("Refine")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.fraction(0.66), .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CardsView(set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}

