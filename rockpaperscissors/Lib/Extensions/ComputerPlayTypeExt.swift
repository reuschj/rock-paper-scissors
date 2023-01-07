//
//  ComputerPlayType.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/8/23.
//

import Foundation

extension ComputerPlayType: StringLocalizable {
    var localizedDescription: String {
        switch self {
        case .random:
            return t("rps_cpt_random")
        case .computerAlwaysWins:
            return t("rps_cpt_cawins")
        case .computerAlwaysLoses:
            return t("rps_cpt_caloses")
        case .computerAlwaysMatches:
            return t("rps_cpt_camatches")
        }
    }
    
    private func t(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
