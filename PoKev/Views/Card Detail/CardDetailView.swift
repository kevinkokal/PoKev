//
//  CardDetailView.swift
//  PoKev
//
//  Created by Kevin Kokal on 2/14/24.
//

import LookingGlassUI
import SwiftUI

struct CardDetailView: View {
    @State var viewModel: CardDetailViewModel
    
    var body: some View {
        AsyncImage(url: viewModel.imageURL) { image in
            let colorFromImage = Color((image.getUIImage()?.averageColor) ?? .white)
            
            image
                .resizable()
                .scaledToFit()
                .shimmer(color: colorFromImage)
        } placeholder: {
            ProgressView()
                .controlSize(.large)
        }
        .motionManager(updateInterval: 0.1, disabled: false)
        .padding(16)
    }
}

#Preview {
    CardDetailView(viewModel: CardDetailViewModel(card: PokemonTCGCard(id: "test", name: "Charmeleon", number: "4", images: PokemonTCGCardImages(small: "https://images.pokemontcg.io/base1/24.png", large: "https://images.pokemontcg.io/base1/24_hires.png"), tcgplayer: PokemonTCGPlayerData(url: "https://prices.pokemontcg.io/tcgplayer/base1-24", updatedAt: "2024/01/25", prices: PokemonTCGPlayerPriceData(holofoil: nil, normal: PokemonTCGPlayerPriceData.PriceDataForType(low: 0.19, mid: 0.99, high: 20.0, market: 1.23, directLow: nil), reverseHolofoil: nil)))))
}
