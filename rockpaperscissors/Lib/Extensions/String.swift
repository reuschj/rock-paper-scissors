//
//  String.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/6/23.
//

import Foundation

extension String {
    func trimEnd() -> String {
        var trimmed = self
        while trimmed.last?.isWhitespace == true {
            trimmed = String(trimmed.dropLast())
        }
        return trimmed
    }
}
