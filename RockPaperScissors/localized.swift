//
//  strings.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/7/23.
//

import Foundation

fileprivate func from(key: String, comment: String? = nil) -> String {
    return NSLocalizedString(key, comment: comment ?? "")
}

postfix operator ~
postfix func ~ (key: String) -> String {
    from(key: key)
}

let t = (
    noResultPlaceholder: "noResultPlaceholder"~,
    winMessage: "winMessage"~,
    tieMessage: "tieMessage"~,
    lossMessage: "lossMessage"~,
    rockPaperOrScissors: "rockPaperOrScissors"~,
    you: "you"~,
    clear: "clear"~,
    options: "options"~,
    computerPlayHeader: { (computerDescription: String) -> String in
        String(format: "computerPlayHeader"~, computerDescription)
    },
    playType: "playType"~,
    aboutYou: "aboutYou"~,
    yourName: "yourName"~,
    howToCallYou: "howToCallYou"~,
    yourGender: "yourGender"~,
    unspecified: "unspecified"~,
    male: "male"~,
    female: "female"~,
    other: "other"~
)
