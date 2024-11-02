//
//  CardsRefinementButton.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI

struct CardsRefinementButton: View {
    @Binding var viewModel: CardsViewModel
    @Environment(PoKevSettings.self) var settings
    
    init(viewModel: Binding<CardsViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.refinementMenuIsPresented = true
        }) {
            if viewModel.refinement.isDefault {
                Image(systemName: "line.3.horizontal.decrease.circle")
            } else {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            }
        }
        .disabled(viewModel.isFetchingCards)
        .sheet(isPresented: $viewModel.refinementMenuIsPresented, onDismiss: {
            viewModel.refineCards(with: settings)
         }) {
            CardsRefinementForm(refinementModel: $viewModel.refinement, configuration: viewModel.configuration)
        }
    }
}
