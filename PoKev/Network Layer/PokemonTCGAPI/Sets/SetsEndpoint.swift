//
//  SetsEndpoint.swift
//  PokeKev
//
//  Created by Kevin Kokal on 01/23/2024.
//

import Foundation

enum SetsEndpoint {
    case sets(mode: PokevSettings.Mode)
}

extension SetsEndpoint: PokemonTCGEndpoint {
    var path: String {
        switch self {
        case .sets:
            return "/v2/sets"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        var searchQuery: String?
        let orderBy: String
        switch self {
        case .sets(let mode):
            switch mode {
            case .unrestricted:
                orderBy = "releaseDate,name"
            case .alana:
                orderBy = "-releaseDate,name"
                searchQuery = "-series:Other -series:NP -series:POP -name:\"EX Trainer Kit\" -name:\"Kalos Starter Set\" -name:\"Scarlet & Violet Energies\" -name:\"Celebrations: Classic Collection\" -name:\"Legendary Collection\" -name:\"Emerging Powers\" -name:\"Base Set 2\""
            case .kevin:
                orderBy = "releaseDate,name"
                searchQuery = "-series:Other -series:NP -series:POP -name:\"Black Star Promos\" -name:\"EX Trainer Kit\" -name:\"Kalos Starter Set\" -name:\"Scarlet & Violet Energies\" -name:\"Celebrations: Classic Collection\" -name:\"Legendary Collection\" -name:\"Emerging Powers\" -name:\"Base Set 2\""
            }
        }
        
        var queryItems = [
            URLQueryItem(name: "select", value: "id,name,series,printedTotal,total,releaseDate,images"),
            URLQueryItem(name: "orderBy", value: orderBy)
        ]
        
        if let searchQuery = searchQuery {
            queryItems.append(URLQueryItem(name: "q", value: searchQuery))
        }
        
        return queryItems
    }
}
