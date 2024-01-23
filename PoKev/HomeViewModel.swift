//
//  HomeViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import Foundation

//TODO: Update to use new observed thing
@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var sets: [PokemonTCGSet] = []
    @Published var hasError: Bool = false

    func fetchSets() async {
        do {
            sets = try await PokemonTCGService().getSets()
        } catch {
            hasError = true
        }
    }
}
