//
//  SetView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import SwiftUI

struct SetView: View {
    @State var viewModel: SetViewModel
    
    init(set: PokemonTCGSet) {
        viewModel = SetViewModel(set: set)
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: viewModel.logoURL) { image in
                image.resizable()
                .scaledToFit()
            } placeholder: {
                ProgressView()
                    .controlSize(.large)
            }
            .frame(width: 96, height: 96)
            .padding(.all, 16)
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.setTitle)
                    .lineLimit(1)
                Spacer()
                AsyncImage(url: viewModel.symbolURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .controlSize(.small)
                }
                .frame(width: 48, height: 48)
                Spacer()
                Button(action: {
                    viewModel.showSetInfo = true
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 24, height: 24)
            }
            .padding(.all, 16)
        }
        .sheet(isPresented: $viewModel.showSetInfo, content: {
            VStack(alignment: .trailing, content: {
                Text(viewModel.seriesTitle)
                    .lineLimit(1)
                Text(viewModel.formattedReleaseDate)
                    .lineLimit(1)
                Text(viewModel.cardCountMessage)
                    .lineLimit(1)
            })
            .presentationDetents([.fraction(0.3)])
            .presentationCornerRadius(25)
        })
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .shadow(color: .gray, radius: 2, x: 0, y: 2))
        .padding(.all, 8)
    }
}

#Preview {
    SetView(set: PokemonTCGSet(id: "test", name: "Test", series: "Dev", printedTotal: 16, total: 19, releaseDate: "2024/01/26", images: PokemonTCGSetImages(symbol: "https://images.pokemontcg.io/base3/symbol.png", logo: "https://images.pokemontcg.io/base3/logo.png")))
}