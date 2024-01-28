//
//  CardView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import SwiftUI

struct CardView: View {
    @State var viewModel: CardViewModel
    
    init(card: PokemonTCGCard) {
        viewModel = CardViewModel(card: card)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CardView(card: PokemonTCGCard(id: "test", name: "Test Card", number: "4", images: PokemonTCGCardImages(small: "https://images.pokemontcg.io/base1/24.png", large: "https://images.pokemontcg.io/base1/24_hires.png"), tcgplayer: PokemonTCGPlayerData(url: "https://prices.pokemontcg.io/tcgplayer/base1-24", updatedAt: "2024/01/25", prices: PokemonTCGPlayerPriceData(holofoil: nil, normal: PokemonTCGPlayerPriceData.PriceDataForType(low: 0.19, mid: 0.99, high: 20.0, market: 1.23, directLow: nil), reverseHolofoil: nil))))
}
