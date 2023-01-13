//
//  getComputerDescription.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/31/22.
//

import SwiftUI

private let computerEmoji = "🖥️ "
private let phoneEmoji = "📱 "
private let iPhone = "iPhone"
private let iPad = "iPad"
private let mac = "Mac"

func getComputerDescription(withoutEmoji: Bool = false, options: Options? = nil) -> String {
    var deviceName = "computer"
    var emoji = withoutEmoji ? "" : computerEmoji
    let your = options?.name != nil ? "\(options?.name ?? "")'s" : "Your"
    #if os(iOS)
        deviceName = UIDevice.current.userInterfaceIdiom == .pad ? iPad : iPhone
        if !withoutEmoji {
            emoji = phoneEmoji
        }
    #else
        deviceName = mac
    #endif
    return "\(emoji)\(your) \(deviceName)"
}

func getLocalizedComputerDescription(withoutEmoji: Bool = false, options: Options? = nil) -> String {
    var deviceName: String? = nil
    var emoji = withoutEmoji ? "" : computerEmoji
#if os(iOS)
    deviceName = UIDevice.current.userInterfaceIdiom == .pad ? iPad : iPhone
    if !withoutEmoji {
        emoji = phoneEmoji
    }
#else
    deviceName = mac
#endif
    let device = deviceName ?? NSLocalizedString("computer", comment: "")
    if let name = options?.name {
        let _template = NSLocalizedString("someonesX", comment: "")
        let deviceFirst = _template.first == "_"
        let template = "\(emoji)\(String(_template.dropFirst()))"
        if deviceFirst {
            return String(format: template, device, name)
        } else {
            return String(format: template, name, device)
        }
    } else {
        let template = "\(emoji)\(NSLocalizedString("yourX", comment: ""))"
        return String(format: template, device)
    }
}

