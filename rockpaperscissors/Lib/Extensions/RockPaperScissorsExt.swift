//
//  RockPaperScissors.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/8/23.
//

import Foundation

extension RockPaperScissors: StringLocalizable {
    public var localizedDescription: String {
        "\(emoji) \(localizedText.uppercased())"
    }
    
    public func localizedDescription(
        vs other: RockPaperScissors
    ) -> String {
        let otherDescription = other.localizedText
        let formatted = String(
            format: localizedDescriptionTemplate(vs: other),
            localizedText.capitalized,
            otherDescription
        )
        return "\(formatted)."
    }
    
    private var localizedText: String {
        switch self {
        case .rock:
            return t("rps_rock")
        case .paper:
            return t("rps_paper")
        case .scissors:
            return t("rps_scissors")
        }
    }
    
    private func localizedDescriptionTemplate(
        vs other: RockPaperScissors
    ) -> String {
        let match = t("rps_vs_match")
        switch self {
        case .rock:
            switch other {
            case .rock: return match
            case .paper: return t("rps_vs_rock_paper")
            case .scissors: return t("rps_vs_rock_scissors")
            }
        case .paper:
            switch other {
            case .rock: return t("rps_vs_paper_rock")
            case .paper: return match
            case .scissors: return t("rps_vs_paper_scissors")
            }
        case .scissors:
            switch other {
            case .rock: return t("rps_vs_scissors_rock")
            case .paper: return t("rps_vs_scissors_paper")
            case .scissors: return match
            }
        }
    }
    
    private func t(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
