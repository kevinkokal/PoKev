//
//  SetsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import LookingGlassUI
import SwiftData
import SwiftUI

struct SetsView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var storedSettings: [PokevSettings]
    @State var viewModel = SetsViewModel()
    @State var settingsModel: PokevSettings?
    @State var previousSettingsModel: PokevSettings?
    
    var sortUpArrowColor: Color {
        viewModel.flipSortOrder ? .accentColor : .primary
    }
    
    var sortDownArrowColor: Color {
        viewModel.flipSortOrder ? .primary : .accentColor
    }
    
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.flipSortOrder.toggle()
                    }, label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(sortUpArrowColor, sortDownArrowColor)
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
                    previousSettingsModel = settingsModel?.copy()
                }
             }) {
                 SettingsForm(settingsModel: Binding($settingsModel)!)
                     .presentationDetents([.fraction(0.50)])
                     .presentationDragIndicator(.visible)
            }
        }
        .onAppear(perform: {
            if let storedSettings = storedSettings.first {
                settingsModel = storedSettings
                previousSettingsModel = storedSettings
            } else {
                let newSettingsModel = PokevSettings()
                modelContext.insert(newSettingsModel)
                settingsModel = newSettingsModel
                previousSettingsModel = newSettingsModel
            }
        })
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
                Section(header: Text("Sets")) {
                    Toggle("Only Standard Sets", isOn: $settingsModel.onlyStandardSets)
                }
                Section(header: Text("Cards")) {
                    Toggle("Include Common and Uncommon", isOn: $settingsModel.includeCommonsAndUncommons)
                    Toggle("Only Generation One", isOn: $settingsModel.onlyGenerationOne)
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

@Model
class PokevSettings: Equatable {
    static func == (lhs: PokevSettings, rhs: PokevSettings) -> Bool {
        lhs.includeCommonsAndUncommons == rhs.includeCommonsAndUncommons && lhs.onlyGenerationOne == rhs.onlyGenerationOne && lhs.onlyStandardSets == rhs.onlyStandardSets
    }
    
    var includeCommonsAndUncommons = true
    var onlyGenerationOne = true
    var onlyStandardSets = true
    
    var isDefault: Bool {
        return includeCommonsAndUncommons && onlyGenerationOne && onlyStandardSets
    }
    
    init(includeCommonsAndUncommons: Bool = true, onlyGenerationOne: Bool = true, onlyStandardSets: Bool = true) {
        self.includeCommonsAndUncommons = includeCommonsAndUncommons
        self.onlyGenerationOne = onlyGenerationOne
        self.onlyStandardSets = onlyStandardSets
    }
    
    func reset() {
        includeCommonsAndUncommons = true
        onlyGenerationOne = true
        onlyStandardSets = true
    }
    
    func copy() -> PokevSettings {
        let settings = PokevSettings(includeCommonsAndUncommons: includeCommonsAndUncommons, onlyGenerationOne: onlyGenerationOne, onlyStandardSets: onlyStandardSets)
        return settings
    }
}
