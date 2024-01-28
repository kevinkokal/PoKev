//
//  SetsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import SwiftUI

struct SetsView: View {
    @State var viewModel = SetsViewModel()

    var body: some View {
        NavigationStack {
            //TODO: is there a better solution? (progress view isn't actually vertically centered)
            if viewModel.isFetchingSets {
                VStack {
                    Spacer()
                    ProgressView()
                        .controlSize(.extraLarge)
                    Spacer()
                }
            }
            ScrollView() {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.sets) { set in
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
            .task {
                await viewModel.fetchSets()
            }
            .alert("", isPresented: $viewModel.shouldPresentError) {} message: {
                Text(viewModel.errorMessage)
            }
            .navigationTitle("Pokemon TCG Sets")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    SetsView()
}
