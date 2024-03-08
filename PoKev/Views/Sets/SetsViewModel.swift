//
//  SetsViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import Foundation
import Observation

@Observable
final class SetsViewModel {
    private(set) var allSets = [PokemonTCGSet]() {
        didSet {
            setsToDisplay = allSets
        }
    }
    private(set) var setsToDisplay = [PokemonTCGSet]()
    private(set) var error: RequestError?
    var shouldPresentError = false
    var isFetchingSets = false
    var settingsMenuIsPresented = false
    
    var searchText = "" {
        didSet {
            filterSets()
        }
    }
    
    var errorMessage: String {
        if let error = self.error {
            return "\(error.customMessage)"
        } else {
            return "Unknown error"
        }
    }

    @MainActor
    func fetchSets(mode: PokevSettings.Mode) async {
        isFetchingSets = true
        do {
            allSets = try await PokemonTCGAPIService().getSets(for: mode)
            isFetchingSets = false
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingSets = false
        }
    }
    
    func filterSets() {
        if searchText.isEmpty {
            setsToDisplay = allSets
        } else {
            setsToDisplay = allSets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
