//
//  SettingsForm.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI

struct SettingsForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var settingsModel: PoKevSettings
    
    init(settingsModel: Binding<PoKevSettings>) {
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
