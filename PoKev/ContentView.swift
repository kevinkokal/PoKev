//
//  ContentView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/23/24.
//

import SwiftUI

struct ContentView: View {
 @StateObject var viewModel = HomeViewModel()

 var body: some View {
  NavigationView {
   ScrollView(showsIndicators: false) {
    LazyVStack {
     ForEach(viewModel.sets, id: \.id) { set in
         Text(set.name)
     }
    }
    .padding()
    .task {
     await viewModel.fetchSets()
    }
    .alert("", isPresented: $viewModel.hasError) {} message: {
     Text("Error fetching sets")
    }
   }
   .navigationTitle("Pokemon TCG Sets")
   .navigationBarTitleDisplayMode(.automatic)
  }
 }
}

#Preview {
    ContentView()
}
