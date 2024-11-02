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
    @State var settingsModel = PoKevSettings()
    @State var previousSettingsModel = PoKevSettings()
    
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
                    await viewModel.fetchSets(with: settingsModel)
                }
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        PokemonListView()
                    } label: {
                        Image(systemName: "list.number")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.flipSortOrder.toggle()
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(viewModel.sortUpArrowColor, viewModel.sortDownArrowColor)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.settingsMenuIsPresented = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                    })
                }
            }
            .sheet(isPresented: $viewModel.settingsMenuIsPresented, onDismiss: {
                if settingsModel != previousSettingsModel {
                    Task {
                        await viewModel.fetchSets(with: settingsModel)
                    }
                    previousSettingsModel = settingsModel.copy()
                }
             }) {
                 SettingsForm(settingsModel: $settingsModel)
                     .presentationDetents([.fraction(0.50)])
                     .presentationDragIndicator(.visible)
            }
        }
        .searchable(text: $viewModel.searchText)
        .environment(settingsModel)
    }
}
