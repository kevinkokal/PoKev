//
//  CardsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import SwiftUI

struct CardsView: View {
    @Environment(PoKevSettings.self) var settings
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
                NoCardsView(refinementMenuIsPresented: $viewModel.refinementMenuIsPresented)
            } else {
                ScrollView() {
                    LazyVGrid(columns: gridItemLayout, spacing: 16) {
                        ForEach(viewModel.cardsToDisplay) { card in
                            CardView(card: card, set: card.set, shouldShowPokedexButton: viewModel.shouldShowPokedexButton, shouldShowSetButton: viewModel.shouldShowSetButton).onTapGesture {
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
                await viewModel.fetchCards(with: settings)
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
                HStack {
                    CarouselButton(viewModel: $viewModel)
                    CardsRefinementButton(viewModel: $viewModel)
                }
            }
        }
        .sheet(isPresented: $viewModel.cardDetailIsPresented) {
            if let selectedCardIndex = viewModel.cardsToDisplay.firstIndex(where: { $0 == viewModel.selectedCard }) {
                CarouselView(imageURLStrings: viewModel.allImageURLStrings, currentIndex: selectedCardIndex)
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}
