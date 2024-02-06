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
                            CardView(card: card, set: viewModel.set)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .task {
            await viewModel.fetchCards()
        }
        .alert("", isPresented: $viewModel.shouldPresentError) {} message: {
            Text(viewModel.errorMessage)
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    print("filter")
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    CardsView(set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}

