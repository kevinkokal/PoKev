//
//  PokemonTCGPlayerData.swift
//  PoKev
//
//  Created by Kevin Kokal on 1 //25/24.
//

import Foundation

struct PokemonTCGPlayerPriceData: Decodable {
    struct PriceDataForType: Decodable {
        let low: Double?
        let mid: Double?
        let high: Double?
        let market: Double?
        let directLow: Double?
    }
    let holofoil: PriceDataForType?
    let normal: PriceDataForType?
    let reverseHolofoil: PriceDataForType?
}

struct PokemonTCGPlayerData: Decodable {
    let url: String
    let updatedAt: String
    let prices: PokemonTCGPlayerPriceData?
}
