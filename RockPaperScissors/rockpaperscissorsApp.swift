//
//  RockPaperScissorsApp.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI

@main
struct RockPaperScissorsApp: App {
    @StateObject var store: Store = .init()

    @Environment(\.openWindow) var openWindow
    
    private let optionsWindowId = "options-window"
    
    var body: some Scene {
        WindowGroup(t.rockPaperOrScissors) {
            ContentView()
                .environmentObject(store)
        }
        .defaultSize(width: 480, height: 720)
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button {
                    openWindow(id: optionsWindowId)
                } label: {
                    Text(t.options)
                }
                .keyboardShortcut(",", modifiers: [.command])
            }
        }
        WindowGroup(t.options, id: optionsWindowId) {
            OptionsPanel()
                .environmentObject(store)
        }
        .defaultSize(width: 480, height: 720)
    }
}
