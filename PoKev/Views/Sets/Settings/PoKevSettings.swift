//
//  PoKevSettings.swift
//  PoKev
//
//  Created by Kevin Kokal on 11/2/24.
//

import Observation

@Observable
class PoKevSettings: Equatable {
    static func == (lhs: PoKevSettings, rhs: PoKevSettings) -> Bool {
        lhs.includeCommonsAndUncommons == rhs.includeCommonsAndUncommons && lhs.onlyGenerationOne == rhs.onlyGenerationOne && lhs.onlyStandardSets == rhs.onlyStandardSets
    }
    
    var includeCommonsAndUncommons = true
    var onlyGenerationOne = true
    var onlyStandardSets = true
    
    var isDefault: Bool {
        return includeCommonsAndUncommons && onlyGenerationOne && onlyStandardSets
    }
    
    init(includeCommonsAndUncommons: Bool = true, onlyGenerationOne: Bool = true, onlyStandardSets: Bool = true) {
        self.includeCommonsAndUncommons = includeCommonsAndUncommons
        self.onlyGenerationOne = onlyGenerationOne
        self.onlyStandardSets = onlyStandardSets
    }
    
    func reset() {
        includeCommonsAndUncommons = true
        onlyGenerationOne = true
        onlyStandardSets = true
    }
    
    func copy() -> PoKevSettings {
        let settings = PoKevSettings(includeCommonsAndUncommons: includeCommonsAndUncommons, onlyGenerationOne: onlyGenerationOne, onlyStandardSets: onlyStandardSets)
        return settings
    }
}
