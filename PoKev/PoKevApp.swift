//
//  PoKevApp.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import SwiftData
import SwiftUI

@main
struct PoKevApp: App {
    var body: some Scene {
        WindowGroup {
            SetsView()
        }
        .modelContainer(for: PokevSettings.self)
    }
}
