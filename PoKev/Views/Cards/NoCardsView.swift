//
//  NoCardsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import SwiftUI

struct NoCardsView: View {
    @Binding var refinementMenuIsPresented: Bool
    
    init(refinementMenuIsPresented: Binding<Bool>) {
        _refinementMenuIsPresented = refinementMenuIsPresented
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(.confusedPsyduck)
                .resizable()
                .frame(width: 256, height: 256)
                .padding(.bottom, 8)
            Text("No Pokemon found...")
                .font(.system(.headline, design: .rounded))
            Button(action: {
                refinementMenuIsPresented = true
            }) {
                Text("Try changing or resetting filters!")
                    .font(.system(.subheadline, design: .rounded))
            }
            Spacer()
        }
    }
}
