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
    @State var settingsModel = PokevSettings()
    @State var previousSettingsModel = PokevSettings()
    
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
                    await viewModel.fetchSets(mode: settingsModel.mode)
                }
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
            .navigationTitle("Pokemon TCG Sets")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        PokemonsView()
                    } label: {
                        Image(systemName: "list.number")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        CardsView()
                    } label: {
                        Image(systemName: "sunglasses.fill")
                    }
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
                        await viewModel.fetchSets(mode: settingsModel.mode)
                    }
                    previousSettingsModel = settingsModel.copy()
                }
             }) {
                 SettingsForm(settingsModel: $settingsModel)
                     .presentationDetents([.fraction(0.33)])
                     .presentationDragIndicator(.visible)
            }
        }
        .searchable(text: $viewModel.searchText)
        .environment(settingsModel)
    }
}

struct SettingsForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var settingsModel: PokevSettings
    
    init(settingsModel: Binding<PokevSettings>) {
        _settingsModel = settingsModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Mode", selection: $settingsModel.mode) {
                    ForEach(PokevSettings.Mode.allCases, id: \.rawValue) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
            }
            .navigationBarItems(leading: Button("Reset", action: { settingsModel.reset() }).disabled(settingsModel.isDefault), trailing: Button("Done", action: { dismiss() }))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
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

@Observable
class PokevSettings: Equatable {
    static func == (lhs: PokevSettings, rhs: PokevSettings) -> Bool {
        lhs.mode == rhs.mode
    }
    
    enum Mode: String, CaseIterable {
        case kevin = "Kevin"
        case alana = "Alana"
        case unrestricted = "Unrestricted"
    }
    
    var mode = Mode.kevin
    
    var isDefault: Bool {
        return mode == .kevin
    }
    
    func reset() {
        mode = .kevin
    }
    
    func copy() -> PokevSettings {
        let settings = PokevSettings()
        settings.mode = mode
        return settings
    }
}
