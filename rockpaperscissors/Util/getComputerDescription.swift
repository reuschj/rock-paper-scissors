//
//  getComputerDescription.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/31/22.
//

import SwiftUI

func getComputerDescription(withoutEmoji: Bool = false, options: Options? = nil) -> String {
    var deviceName = "computer"
    var emoji = withoutEmoji ? "" : "🖥️"
    var your = options?.name != nil ? "\(options?.name ?? "")'s" : "Your"
    #if os(iOS)
        deviceName = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        if !withoutEmoji {
            emoji = "📱"
        }
    #else
        deviceName = "Mac"
    #endif
    return "\(emoji) \(your) \(deviceName)"
}
