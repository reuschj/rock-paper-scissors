//
//  getComputerDescription.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/31/22.
//

import SwiftUI

func getComputerDescription(withoutEmoji: Bool = false) -> String {
    var deviceName = "computer"
    var emoji = withoutEmoji ? "" : "🖥️"
    #if os(iOS)
        deviceName = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        if !withoutEmoji {
            emoji = "📱"
        }
    #else
        deviceName = "Mac"
    #endif
    return "\(emoji) Your \(deviceName)"
}
