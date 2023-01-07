//
//  RPSResult.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/8/23.
//

import Foundation

extension RPSResult : StringLocalizable {
    public var localizedDescription: String {
        switch self {
        case .win:
            return t("rps_win")
        case .tie:
            return t("rps_tie")
        case .loss:
            return t("rps_loss")
        }
    }
    
    private func t(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
