//
//  CardsRefinementForm.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI
import MultiPicker

struct CardsRefinementForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var refinementModel: CardsRefinementConfiguration
    private let configuration: CardsViewModel.Configuration
    
    init(refinementModel: Binding<CardsRefinementConfiguration>, configuration: CardsViewModel.Configuration) {
        _refinementModel = refinementModel
        self.configuration = configuration
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Property", selection: $refinementModel.currentSort.property) {
                        Text("Alphabetical").tag(CardsRefinementConfiguration.Sort.Property.alphabetical)
                        switch configuration {
                        case .set:
                            Text("Number in Set").tag(CardsRefinementConfiguration.Sort.Property.setNumber)
                            Text("Number in Pokedex").tag(CardsRefinementConfiguration.Sort.Property.pokedexNumber)
                        case .pokedexNumber:
                            Text("Release Date").tag(CardsRefinementConfiguration.Sort.Property.releaseDate)
                        }
                    }
                    Picker("Order", selection: $refinementModel.currentSort.order) {
                        Text("Ascending").tag(SortOrder.forward)
                        Text("Descending").tag(SortOrder.reverse)
                    }
                }
                Section(header: Text("Price Filters")) {
                    Toggle("Only show potential deals", isOn: $refinementModel.filters.onlyPotentialDeals)
                }
                Section(header: Text("Rarity Filters")) {
                    MultiPicker("Only show certain rarities", selection: $refinementModel.filters.rarities) {
                        ForEach(Array(refinementModel.filters.allRaritiesInSet), id:\.self) { rarity in
                            Text(rarity).mpTag(rarity)
                        }
                    }
                }
            }
            .navigationBarItems(leading: Button("Reset", action: { refinementModel.reset() }).disabled(refinementModel.isDefault), trailing: Button("Done", action: { dismiss() }))
            .navigationTitle("Refine")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
