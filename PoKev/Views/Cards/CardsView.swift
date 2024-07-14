//
//  CardsView.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/28/24.
//

import MultiPicker
import SwiftUI

struct CardsView: View {
    @Environment(PokevSettings.self) var settings
    @State var viewModel: CardsViewModel
    
    private let gridItemLayout =  [GridItem(.flexible()), GridItem(.flexible())]
    
    init(set: PokemonTCGSet) {
        viewModel = CardsViewModel(set: set)
    }
    
    init(pokedexNumber: Int) {
        viewModel = CardsViewModel(pokedexNumber: pokedexNumber)
    }
    
    init() {
        viewModel = CardsViewModel()
    }
    
    var body: some View {
        Group {
            if viewModel.isFetchingCards {
                PokeBallProgressView()
            } else if viewModel.shouldShowNoResultsScreen {
                NoResultsScreen(refinementMenuIsPresented: $viewModel.refinementMenuIsPresented)
            } else {
                ScrollView() {
                    LazyVGrid(columns: gridItemLayout, spacing: 16) {
                        ForEach(viewModel.cardsToDisplay) { card in
                            CardView(card: card, set: card.set, shouldShowPokedexButton: viewModel.shouldShowPokedexButton, shouldShowSetButton: viewModel.shouldShowSetButton).onTapGesture {
                                viewModel.cardDetailIsPresented = true
                                viewModel.selectedCard = card
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .task {
            if viewModel.allCards.isEmpty {
                await viewModel.fetchCards(with: settings)
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.shouldPresentError) {}
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.navigationTitle).font(.headline)
                    if !viewModel.cardsToDisplay.isEmpty {
                        Text(viewModel.navigationSubTitle).font(.subheadline)
                    }
                }
            }
            ToolbarItem {
                HStack {
                    CarouselButton(viewModel: $viewModel)
                    RefinementButton(viewModel: $viewModel)
                }
            }
        }
        .sheet(isPresented: $viewModel.cardDetailIsPresented) {
            if let selectedCardIndex = viewModel.cardsToDisplay.firstIndex(where: { $0 == viewModel.selectedCard }) {
                CarouselView(imageURLStrings: viewModel.allImageURLStrings, currentIndex: selectedCardIndex)
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
            }
        }
        .searchable(text: $viewModel.searchText)
    }
    
    enum ActiveSheet {
       case first, second
       var id: Int {
          hashValue
       }
    }
}

struct RefinementForm: View {
    @Environment(\.dismiss) var dismiss
    @Binding var refinementModel: CardsRefinement
    private let configuration: CardsViewModel.Configuration
    
    init(refinementModel: Binding<CardsRefinement>, configuration: CardsViewModel.Configuration) {
        _refinementModel = refinementModel
        self.configuration = configuration
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort")) {
                    Picker("Property", selection: $refinementModel.currentSort.property) {
                        Text("Alphabetical").tag(CardsRefinement.Sort.Property.alphabetical)
                        switch configuration {
                        case .set:
                            Text("Number in Set").tag(CardsRefinement.Sort.Property.setNumber)
                            Text("Number in Pokedex").tag(CardsRefinement.Sort.Property.pokedexNumber)
                        case .pokedexNumber:
                            Text("Release Date").tag(CardsRefinement.Sort.Property.releaseDate)
                        case .tagged:
                            Text("Watched Date").tag(CardsRefinement.Sort.Property.watchedDate)
                            Text("Release Date").tag(CardsRefinement.Sort.Property.releaseDate)
                            Text("Number in Pokedex").tag(CardsRefinement.Sort.Property.pokedexNumber)
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

struct NoResultsScreen: View {
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

struct RefinementButton: View {
    @Binding var viewModel: CardsViewModel
    @Environment(PokevSettings.self) var settings
    
    init(viewModel: Binding<CardsViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.refinementMenuIsPresented = true
        }) {
            if viewModel.refinement.isDefault {
                Image(systemName: "line.3.horizontal.decrease.circle")
            } else {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            }
        }
        .disabled(viewModel.isFetchingCards)
        .sheet(isPresented: $viewModel.refinementMenuIsPresented, onDismiss: {
            viewModel.refineCards(with: settings)
         }) {
            RefinementForm(refinementModel: $viewModel.refinement, configuration: viewModel.configuration)
        }
    }
}

struct CarouselButton: View {
    @Binding var viewModel: CardsViewModel
    
    init(viewModel: Binding<CardsViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
        Button(action: {
            viewModel.carouselViewIsPresented = true
        }) {
            Image(systemName: "square.3.layers.3d.down.left")
        }
        .disabled(viewModel.isFetchingCards)
        .sheet(isPresented: $viewModel.carouselViewIsPresented) {
            CarouselView(imageURLStrings: viewModel.allImageURLStrings)
                .presentationDetents([.fraction(0.80)])
                .presentationDragIndicator(.visible)
        }
    }
}
