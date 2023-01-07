//
//  ComputerPlayType.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import Foundation

enum ComputerPlayType: CustomStringConvertible {
    case random
    case computerAlwaysWins
    case computerAlwaysLoses
    case computerAlwaysMatches
    
    init?(string: String) {
        switch string.lowercased() {
        case "0", "r", "rand", "rndm", "random": self = .random
        case "1", "win", "alwayswin": self = .computerAlwaysWins
        case "2", "lose", "alwayslose": self = .computerAlwaysLoses
        case "3", "match", "alwaysmatch": self = .computerAlwaysMatches
        default: return nil
        }
    }
    
    var description: String {
        switch self {
        case .random:
            return "Random"
        case .computerAlwaysWins:
            return "Computer always wins"
        case .computerAlwaysLoses:
            return "Computer always loses"
        case .computerAlwaysMatches:
            return "Computer always matches"
        }
    }
}

struct ComputerPlayTypeHolder: Identifiable, Hashable {
    let id: UUID = .init()
    let type: ComputerPlayType
    
    init(_ type: ComputerPlayType = .random) {
        self.type = type
    }
    
    static let all: [ComputerPlayTypeHolder] = [
        .init(.random),
        .init(.computerAlwaysWins),
        .init(.computerAlwaysLoses),
        .init(.computerAlwaysMatches)
    ]
}
