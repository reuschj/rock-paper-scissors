//
//  RockPaperScissors.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import Foundation

public enum RockPaperScissors: Int, RawRepresentable, CustomStringConvertible, Hashable {
    case rock = 1
    case paper = 2
    case scissors = 3

    public var description: String {
        "\(emoji) \(text.uppercased())"
    }
    
    public var emoji: Character {
        switch self {
        case .rock:
            return "🪨"
        case .paper:
            return "📄"
        case .scissors:
            return "✂️"
        }
    }
    
    public var text: String {
        switch self {
        case .rock:
            return "rock"
        case .paper:
            return "paper"
        case .scissors:
            return "scissors"
        }
    }

    public init?(rawValue: Int) {
        switch rawValue {
        case 1: self = .rock
        case 2: self = .paper
        case 3: self = .scissors
        default: return nil
        }
    }

    public init?(string: String) {
        switch string.lowercased() {
        case "r", "rk", "rck", "rock", "a": self = .rock
        case "p", "pp", "pr", "ppr", "paper", "b": self = .paper
        case "s", "sc", "ss", "sr", "ssr", "scr", "scissors", "c": self = .scissors
        case "rand", "rnd", "rndm", "random": self = .random
        default: return nil
        }
    }

    public init?(char: Character) {
        switch char.lowercased() {
        case "a": self = .rock
        case "b": self = .paper
        case "c": self = .scissors
        default: return nil
        }
    }

    enum CodingKeys: String, CodingKey {
        case title, salary
    }

    public static var random: RockPaperScissors {
        let random = Int.random(in: 1...3)
        return .init(rawValue: random)!
    }

    public static func from(char: Character) -> RockPaperScissors? {
        .init(char: char)
    }

    public var char: Character {
        switch self {
        case .rock:
            return "A"
        case .paper:
            return "B"
        case .scissors:
            return  "C"
        }
    }
}

extension RockPaperScissors: Comparable {
    public static func < (lhs: RockPaperScissors, rhs: RockPaperScissors) -> Bool {
        switch lhs {
        case .rock:
            switch rhs {
            case .rock, .scissors: return false
            case .paper: return true
            }
        case .paper:
            switch rhs {
            case .paper, .rock: return false
            case .scissors: return true
            }
        case .scissors:
            switch rhs {
            case .scissors, .paper: return false
            case .rock: return true
            }
        }
    }

    public func description(vs other: RockPaperScissors) -> String {
        let match = "is the same as"
        switch self {
        case .rock:
            switch other {
            case .rock: return match
            case .paper: return "was covered by"
            case .scissors: return "smashed"
            }
        case .paper:
            switch other {
            case .rock: return "covered"
            case .paper: return match
            case .scissors: return "was cut by"
            }
        case .scissors:
            switch other {
            case .rock: return "was smashed by"
            case .paper: return "cut"
            case .scissors: return match
            }
        }
    }
}

struct RPSHolder: Identifiable {
    let type: RockPaperScissors
    let id: UUID = .init()
    
    init(_ type: RockPaperScissors = .random) {
        self.type = type
    }
    
    static let all: [RPSHolder] = [.init(), .init(.rock), .init(.paper), .init(.scissors)]
}
