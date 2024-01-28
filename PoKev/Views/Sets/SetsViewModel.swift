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
    private(set) var sets = [PokemonTCGSet]()
    private(set) var error: RequestError?
    var shouldPresentError = false
    var isFetchingSets = false
    
    var errorMessage: String {
        if let error = self.error {
            return "\(error.customMessage)"
        } else {
            return "Unknown error"
        }
    }

    func fetchSets() async {
        //TODO: Added is empty check to prevent spinner showing up when it shouldn't...
        if sets.isEmpty{
            isFetchingSets = true
        }
        do {
            sets = try await PokemonTCGService().getSets()
            isFetchingSets = false
        } catch let error {
            self.error = error as? RequestError
            shouldPresentError = true
            isFetchingSets = false
        }
    }
}
