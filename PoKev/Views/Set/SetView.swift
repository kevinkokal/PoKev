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
            CacheAsyncImage(url: viewModel.logoURL) { image in
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
                    .lineLimit(2)
                    .font(.title2)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                Spacer()
                Text(viewModel.seriesTitle)
                    .lineLimit(1)
                    .font(.subheadline)
                    .fontDesign(.rounded)
                Spacer()
                CacheAsyncImage(url: viewModel.symbolURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .controlSize(.small)
                }
                .frame(width: 48, height: 48)
                Spacer()
                Text(viewModel.cardCountMessage)
                    .lineLimit(1)
                    .font(.headline)
                    .fontDesign(.rounded)
            }
            .padding(.all, 16)
        }
        .background(RoundedRectangle(cornerRadius: 24)
            .fill(Color("DefaultCardBackground"))
            .shadow(color: .gray, radius: 3, x: 0, y: 3))
        .padding(.all, 8)
    }
}
