//
//  CarouselView.swift
//  PoKev
//
//  Created by Kevin Kokal on 2/29/24.
//

import SwiftUI

struct CarouselView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    let imageURLStrings: [String]
    
    init(imageURLStrings: [String]) {
        self.imageURLStrings = imageURLStrings
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ForEach(0..<imageURLStrings.count, id:\.self) { index in
                        CarouselImage(urlString: imageURLStrings[index], currentIndex: $currentIndex, index: index, dragOffset: $dragOffset)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            dragOffset = value.location.x - value.startLocation.x
                        })
                        .onEnded({ value in
                            let threshold: CGFloat = 24
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                    dragOffset = 0
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min(imageURLStrings.count - 1, currentIndex + 1)
                                    dragOffset = 0
                                }
                            }
                        })
                )
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                        }
                        .disabled(currentIndex == 0)
                        Spacer()
                        Button {
                            withAnimation {
                                currentIndex = min(imageURLStrings.count - 1, currentIndex + 1)
                            }
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.title)
                        }
                        .disabled(currentIndex == imageURLStrings.count - 1)
                    }
                }
            }
        }
    }
}

private struct CarouselImage: View {
    var urlString: String
    @Binding var currentIndex: Int
    var index: Int
    @Binding var dragOffset: CGFloat
    
    init(urlString: String, currentIndex: Binding<Int>, index: Int, dragOffset: Binding<CGFloat>) {
        self.urlString = urlString
        _currentIndex = currentIndex
        self.index = index
        _dragOffset = dragOffset
    }
    
    var body: some View {
        CacheAsyncImage(url: URL(string: urlString)) { image in
            var opacity: CGFloat {
                if abs(index - currentIndex) > 1 {
                    return 0.5
                } else {
                    return currentIndex == index && dragOffset == 0 ? 1.0 : (currentIndex != index ? 0.5 + 0.5 * min(abs(dragOffset), 300)/300 : 1.0 - 0.5 * min(abs(dragOffset), 300)/300)
                }
            }
            var scaleEffect: CGFloat {
                if abs(index - currentIndex) > 1 {
                    return 0.8
                } else {
                    return currentIndex == index && dragOffset == 0 ? 1.2 : (currentIndex != index ? 0.8 + 0.4 * min(abs(dragOffset), 300)/300 : 1.2 - 0.4 * min(abs(dragOffset), 300)/300)
                }
            }
            image
                .resizable()
                .frame(width: 300, height: 400)
                .opacity(opacity)
                .scaleEffect(scaleEffect)
                .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset, y: 0)
        } placeholder: {
            PokeBallProgressView()
                .opacity(currentIndex == index ? 1.0 : 0.5)
                .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset, y: 0)
        }
    }
}

#Preview {
    CarouselView(imageURLStrings: ["https://prices.pokemontcg.io/tcgplayer/base1-72", "https://prices.pokemontcg.io/tcgplayer/base1-71", "https://prices.pokemontcg.io/tcgplayer/base1-70", "https://prices.pokemontcg.io/tcgplayer/base1-69"])
}
