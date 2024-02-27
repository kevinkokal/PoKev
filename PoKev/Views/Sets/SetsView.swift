//
//  SetsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import LookingGlassUI
import SwiftUI

struct SetsView: View {
    @State var viewModel = SetsViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isFetchingSets {
                    PokeBallProgressView()
                } else {
                    ScrollView() {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.setsToDisplay) { set in
                                NavigationLink {
                                    CardsView(set: set)
                                } label: {
                                    SetView(set: set)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding([.leading, .trailing], 8)
                    }
                }
            }
            .task {
                if viewModel.allSets.isEmpty {
                    await viewModel.fetchSets()
                }
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
            .navigationTitle("Pokemon TCG Sets")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .searchable(text: $viewModel.searchText)
    }
}

struct PokeBallProgressView: View {
    @State var angle: Double = 0.0
    @State var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation
            .spring(duration: 0.4, bounce: 0)
            .delay(0.2)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(.ball)
            .resizable()
            .frame(width: 128, height: 128)
            .rotationEffect(Angle(degrees: isAnimating ? 360.0 : 0.0))
            .animation(self.foreverAnimation, value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    SetsView()
}
