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
    
    private let gridItemLayout =  [GridItem(.flexible()), GridItem(.flexible())]
    
    init(set: PokemonTCGSet) {
        viewModel = CardsViewModel(set: set)
    }
    
    init(pokedexNumber: Int) {
        viewModel = CardsViewModel(pokedexNumber: pokedexNumber)
    }
    
    var body: some View {
        Group {
            if viewModel.isFetchingCards {
                PokeBallProgressView()
            } else if viewModel.shouldShowNoResultsScreen {
                NoResultsScreen(refinementMenuIsPresented: $viewModel.refinementMenuIsPresented)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridItemLayout, spacing: 16) {
                        ForEach(viewModel.cardsToDisplay) { card in
                            CardView(card: card, set: card.set, shouldShowPokedexButton: viewModel.shouldShowPokedexButton).onTapGesture {
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
                    if !viewModel.cardsToDisplay.isEmpty {
                        Text(viewModel.navigationSubTitle).font(.subheadline)
                    }
                }
            }
            ToolbarItem {
                RefinementButton(viewModel: $viewModel)
            }
        }
        .sheet(isPresented: $viewModel.cardDetailIsPresented) {
            if let selectedCard = viewModel.selectedCard {
                CardDetailView(viewModel: CardDetailViewModel(card: selectedCard))
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
            }
        }
        .searchable(text: $viewModel.searchText)
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
    @Binding var refinementModel: CardsRefinement
    private let configuration: CardsViewModel.Configuration
    
    init(refinementModel: Binding<CardsRefinement>, configuration: CardsViewModel.Configuration) {
        _refinementModel = refinementModel
        self.configuration = configuration
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Sort Order", selection: $refinementModel.currentSortOrder) {
                        Text("Alphabetical").tag(CardsRefinement.SortOrder.alphabetical)
                        switch configuration {
                        case .set:
                            Text("Number in Set").tag(CardsRefinement.SortOrder.setNumber)
                            Text("Number in Pokedex").tag(CardsRefinement.SortOrder.pokedexNumber)
                        case .pokedexNumber:
                            Text("Release Date").tag(CardsRefinement.SortOrder.releaseDate)
                        }
                    }
                }
                Section(header: Text("Price Filters")) {
                    Toggle("Only show potential deals", isOn: $refinementModel.filters.onlyPotentialDeals)
                }
                Section(header: Text("Rarity Filters")) {
                    MultiPicker("Only show certain rarities", selection: $refinementModel.filters.rarities) {
                        ForEach(Array(refinementModel.filters.allRaritiesInSet), id:\.self) { rarity in
                            Text(rarity).mpTag(rarity)
                        }
                    }
                }
            }
            .navigationBarItems(leading: Button("Reset", action: { refinementModel.reset() }), trailing: Button("Done", action: { dismiss() }))
            .navigationTitle("Refine")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NoResultsScreen: View {
    @Binding var refinementMenuIsPresented: Bool
    
    init(refinementMenuIsPresented: Binding<Bool>) {
        _refinementMenuIsPresented = refinementMenuIsPresented
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(.confusedPsyduck)
                .resizable()
                .frame(width: 256, height: 256)
                .padding(.bottom, 8)
            Text("No Pokemon found...")
                .font(.system(.headline, design: .rounded))
            Button(action: {
                refinementMenuIsPresented = true
            }) {
                Text("Try changing or resetting filters!")
                    .font(.system(.subheadline, design: .rounded))
            }
            Spacer()
        }
    }
}

struct RefinementButton: View {
    @Binding var viewModel: CardsViewModel
    
    init(viewModel: Binding<CardsViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
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
        .sheet(isPresented: $viewModel.refinementMenuIsPresented, onDismiss: {
            viewModel.refineCards()
         }) {
            RefinementForm(refinementModel: $viewModel.refinement, configuration: viewModel.configuration)
        }
    }
}

#Preview {
    CardsView(set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}

