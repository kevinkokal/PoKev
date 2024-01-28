//
//  SetViewModel.swift
//  PoKev
//
//  Created by Kevin Kokal on 1/25/24.
//

import Foundation
import Observation

@Observable
final class SetViewModel {
    @ObservationIgnored let set: PokemonTCGSet
    var showSetInfo = false
    
    var cardCountMessage: String {
        let secretCount = set.total - set.printedTotal
        var countMessage = "\(set.total) Cards"
        if secretCount > 0 {
            countMessage += " (\(secretCount) secret rares)"
        }
        return countMessage
    }
    
    var setTitle: String {
        return set.name + " Set"
    }
    
    var seriesTitle: String {
        return set.series
    }
    
    var formattedReleaseDate: String {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = apiDateFormatter.date(from: set.releaseDate) {
            let uiDateFormatter = DateFormatter()
            uiDateFormatter.dateStyle = .long
            return uiDateFormatter.string(from: date)
        } else {
            return "Unknown"
        }
    }
    
    var logoURL: URL? {
        return URL(string: set.images.logo)
    }
    
    var symbolURL: URL? {
        return URL(string: set.images.symbol)
    }
    
    init(set: PokemonTCGSet) {
        self.set = set
    }
}
