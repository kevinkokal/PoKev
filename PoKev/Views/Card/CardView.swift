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
                // TODO: tag
                /*Spacer()
                Menu {
                    Button("Watch", action: watch)
                    Button("Favorite", action: favorite)
                } label: {
                    Image(systemName: viewModel.watched ? "tag.fill" : "tag")
                        .font(.title2)
                }*/
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
    
    func favorite() { 
        viewModel.watched.toggle()
    }
    func watch() { 
        viewModel.watched.toggle()
    }
}
