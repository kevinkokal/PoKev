//
//  PokemonView.swift
//  PoKev
//
//  Created by Kevin Kokal on 3/6/24.
//

import SwiftUI

struct PokemonView: View {
    @State var viewModel: PokemonViewModel
    
    init(name: String, number: Int) {
        viewModel = PokemonViewModel(name: name, number: number)
    }
    
    var body: some View {
        HStack {
            CacheAsyncImage(url: URL(string: viewModel.imageURLString)){ image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
                    .controlSize(.small)
            }
            .frame(width: 72, height: 72)
            .padding([.leading, .top, .bottom], 8)
            Text(viewModel.name.capitalized)
                .lineLimit(1)
                .font(.title2)
                .fontDesign(.rounded)
            Spacer()
            Text("#\(viewModel.numberToDisplay)")
                .lineLimit(1)
                .font(.headline)
                .fontDesign(.rounded)
                .padding(.all, 16)
        }
        .background(RoundedRectangle(cornerRadius: 24)
            .fill(Color("DefaultCardBackground"))
            .shadow(color: .gray, radius: 3, x: 0, y: 3))
        .padding(.all, 8)
    }
}

#Preview {
    PokemonView(name: "Bulbasaur", number: 1)
}
