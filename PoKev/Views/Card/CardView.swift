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
    
    init(card: PokemonTCGCard, set: PokemonTCGSet) {
        viewModel = CardViewModel(card: card, set: set)
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: viewModel.imageURL) { image in
                
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .controlSize(.large)
            }
                .frame(width: 128, height: 128)
            Text(viewModel.cardTitle)
                .font(.system(.headline, design: .rounded))
                .lineLimit(1)
            Text(viewModel.cardSubtitle)
                .font(.system(.subheadline, design: .rounded))
                .lineLimit(1)
            Spacer()
            HStack {
                Spacer()
                if let url = viewModel.tcgPlayerURL {
                    Link(destination: url) {
                        Image(systemName: "cart")
                            .font(.title2)
                    }
                } else {
                    Image(systemName: "cart.badge.questionmark")
                        .font(.title2)
                }
                Spacer()
                Button(action: {
                    print("info")
                }) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                }
                Spacer()
            }
        }
        .padding(.all, 16)
        .background(RoundedRectangle(cornerRadius: 24)
        .fill(viewModel.backgroundColor)
        .shadow(color: .gray, radius: 3, x: 0, y: 3))
    }
}

#Preview {
    CardView(card: PokemonTCGCard(id: "test", name: "Charmeleon", rarity: "Uncommon", number: "4", nationalPokedexNumbers: [24], images: PokemonTCGCardImages(small: "https://images.pokemontcg.io/base1/24.png", large: "https://images.pokemontcg.io/base1/24_hires.png"), tcgplayer: PokemonTCGPlayerData(url: "https://prices.pokemontcg.io/tcgplayer/base1-24", updatedAt: "2024/01/25", prices: PokemonTCGPlayerPriceData(holofoil: nil, normal: PokemonTCGPlayerPriceData.PriceDataForType(low: 0.19, mid: 0.99, high: 20.0, market: 1.23, directLow: nil), reverseHolofoil: nil)), set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png"))), set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}
