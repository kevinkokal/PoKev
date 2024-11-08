//
//  PokemonTCGCard.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation

struct PokemonTCGCardImages: Decodable {
    let small: String?
    let large: String?
}

struct PokemonTCGCard: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let rarity: String?
    let number: String
    let nationalPokedexNumbers: [Int]?
    let images: PokemonTCGCardImages
    let tcgplayer: PokemonTCGPlayerData?
    let set: PokemonTCGSet
    
    static func == (lhs: PokemonTCGCard, rhs: PokemonTCGCard) -> Bool {
        lhs.id == rhs.id
    }
    
    // Custom logic for determining a deal based on set release data, price data, card printing type
    var isPotentialDeal: Bool {
        if let holofoilPriceData = tcgplayer?.prices?.holofoil, let directLow = holofoilPriceData.directLow, let market = holofoilPriceData.market {
            return directLow <= market
        } else {
            let apiDateFormatter = DateFormatter()
            apiDateFormatter.dateFormat = "yyyy/MM/dd"
            
            if let date = apiDateFormatter.date(from: set.releaseDate), let xyDate = apiDateFormatter.date(from: "2014/02/05") {
                if date < xyDate {
                    if let normalPriceData = tcgplayer?.prices?.normal, let directLow = normalPriceData.directLow, let market = normalPriceData.market {
                        return (directLow <= market && directLow >= market * 0.6)
                    } else if let revereHolofoilPriceData = tcgplayer?.prices?.reverseHolofoil, let directLow = revereHolofoilPriceData.directLow, let market = revereHolofoilPriceData.market {
                        return (directLow <= market && directLow >= market * 0.6)
                    }
                }
            }
        }
        
        return false
    }
}
