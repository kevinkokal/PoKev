//
//  CarouselButton.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI

struct CarouselButton: View {
    @Binding var viewModel: CardsViewModel
    
    init(viewModel: Binding<CardsViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.carouselViewIsPresented = true
        }) {
            Image(systemName: "square.3.layers.3d.down.left")
        }
        .disabled(viewModel.isFetchingCards)
        .sheet(isPresented: $viewModel.carouselViewIsPresented) {
            CarouselView(imageURLStrings: viewModel.allImageURLStrings)
                .presentationDetents([.fraction(0.80)])
                .presentationDragIndicator(.visible)
        }
    }
}
