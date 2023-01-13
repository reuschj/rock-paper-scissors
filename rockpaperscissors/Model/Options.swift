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
    @Published var computerPlayType: RockPaperScissors.ComputerPlayType = .random
    @Published var name: String?
    @Published var gender: Gender?
    
    static var shared: Options = .init()
}

