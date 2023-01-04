//
//  RPSResult.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

public enum RPSResult: Int, RawRepresentable, CustomStringConvertible {
    case win = 2
    case tie = 1
    case loss = 0

    public static func from(_ own: RockPaperScissors, vs opponent: RockPaperScissors) -> RPSResult {
        if own > opponent {
            return .win
        } else if opponent > own {
            return .loss
        } else {
            return .tie
        }
    }

    public var description: String {
        switch self {
        case .win:
            return "Win"
        case .tie:
            return "Tie"
        case .loss:
            return "Loss"
        }
    }

    public func howToGet(vs opponent: RockPaperScissors) -> RockPaperScissors {
        switch self {
        case .win:
            switch opponent {
            case .rock: return .paper
            case .paper: return .scissors
            case .scissors: return .rock
            }
        case .tie:
            return opponent
        case .loss:
            switch opponent {
            case .rock: return .scissors
            case .paper: return .rock
            case .scissors: return .paper
            }
        }
    }
}
