//
//  CardView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import LookingGlassUI
import SwiftUI
import UIKit

struct CardView: View {
    @State var viewModel: CardViewModel
    
    init(card: PokemonTCGCard, set: PokemonTCGSet, shouldShowPokedexButton: Bool, shouldShowSetButton: Bool) {
        viewModel = CardViewModel(card: card, set: set, shouldShowPokedexButton: shouldShowPokedexButton, shouldShowSetButton: shouldShowSetButton)
    }
    
    var body: some View {
        VStack {
            CacheAsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .cornerRadius(2)
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .controlSize(.large)
            }
            .frame(width: 128, height: 128)
            Spacer()
            Text(viewModel.cardTitle)
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            if viewModel.shouldShowSetButton {
                NavigationLink {
                    CardsView(set: viewModel.set)
                } label: {
                    Text(viewModel.set.name)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(2)
                }
            }
            Text(viewModel.cardSubtitle)
                .font(.system(.subheadline, design: .rounded))
                .lineLimit(1)
            Spacer()
            HStack {
                Spacer()
                if let url = viewModel.tcgPlayerURL {
                    Link(destination: url) {
                        Image(systemName: "cart.fill")
                            .font(.title2)
                    }
                } else {
                    Image(systemName: "cart.fill.badge.questionmark")
                        .font(.title2)
                }
                Spacer()
                if let pokedexNumbers = viewModel.card.nationalPokedexNumbers, viewModel.shouldShowPokedexButton {
                    if pokedexNumbers.count > 1 {
                        Menu {
                            Text("Select Pokedex Number")
                            ForEach(pokedexNumbers, id: \.self) { pokedexNumber in
                                NavigationLink {
                                    CardsView(pokedexNumber: pokedexNumber)
                                } label: {
                                    Text("\(pokedexNumber)")
                                }
                            }
                        } label: {
                            Image(systemName: "book.pages.fill")
                                .font(.title2)
                        }
                    } else {
                        NavigationLink {
                            CardsView(pokedexNumber: pokedexNumbers.first!)
                        } label: {
                            Image(systemName: "book.pages.fill")
                                .font(.title2)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding(.all, 16)
        .background(RoundedRectangle(cornerRadius: 24)
            .fill(Color("DefaultCardBackground"))
        .shadow(color: .gray, radius: 3, x: 0, y: 3))
        .overlay {
            if let highlightColor = viewModel.highlightColor {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(highlightColor, lineWidth: 2)
            }
        }
    }
}

#Preview {
    CardView(card: PokemonTCGCard(id: "test", name: "Charmeleon", rarity: "Uncommon", number: "4", nationalPokedexNumbers: [24], images: PokemonTCGCardImages(small: "https://images.pokemontcg.io/base1/24.png", large: "https://images.pokemontcg.io/base1/24_hires.png"), tcgplayer: PokemonTCGPlayerData(url: "https://prices.pokemontcg.io/tcgplayer/base1-24", updatedAt: "2024/01/25", prices: PokemonTCGPlayerPriceData(holofoil: nil, normal: PokemonTCGPlayerPriceData.PriceDataForType(low: 0.19, mid: 0.99, high: 20.0, market: 1.23, directLow: nil), reverseHolofoil: nil)), set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png"))), set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")), shouldShowPokedexButton: true, shouldShowSetButton: true)
}
