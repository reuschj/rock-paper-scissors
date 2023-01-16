//
//  Options.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/31/22.
//

import Foundation
import Combine
import RockPaperScissorsAPI
import RockPaperScissorsAppAPI

class Options: ObservableObject {
    @Published var computerPlayType: RockPaperScissors.ComputerPlayType = .random {
        didSet { UserDefaults.standard.set(computerPlayType.rawValue, forKey: DefaultsKeys.computerPlayType) }
    }

    @Published var name: String? {
        didSet { UserDefaults.standard.set(name, forKey: DefaultsKeys.name) }
    }

    @Published var gender: Gender? {
        didSet { UserDefaults.standard.set(gender?.rawValue, forKey: DefaultsKeys.gender) }
    }
    
    init() {
        loadFromDefaults()
    }
    
    private func loadFromDefaults() {
        let userDefaults: UserDefaults = .standard
        let defaultsAreSet = userDefaults.bool(forKey: DefaultsKeys.defaultsAreSet)
        
        if !defaultsAreSet {
            userDefaults.set(true, forKey: DefaultsKeys.defaultsAreSet)
            userDefaults.set(RockPaperScissors.ComputerPlayType.random.rawValue, forKey: DefaultsKeys.computerPlayType)
            userDefaults.set(nil, forKey: DefaultsKeys.name)
            userDefaults.set(nil, forKey: DefaultsKeys.gender)
        }
        
        let rawComputerPlayType = userDefaults.string(forKey: DefaultsKeys.computerPlayType)
        let rawName = userDefaults.string(forKey: DefaultsKeys.name)
        let rawGender = userDefaults.string(forKey: DefaultsKeys.gender)

        if let rawComputerPlayType = rawComputerPlayType {
            self.computerPlayType = .init(rawValue: rawComputerPlayType) ?? .random
        } else {
            self.computerPlayType = .random
        }

        if let rawName = rawName {
            self.name = rawName.count > 0 ? rawName : nil
        }

        if let rawGender = rawGender {
            self.gender = .init(rawValue: rawGender)
        }
    }
    
    static var shared: Options = .init()
}

