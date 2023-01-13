//
//  OptionsPanel.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/30/22.
//

import SwiftUI
import Combine
import RockPaperScissorsAPI
import RockPaperScissorsAppAPI

fileprivate var options: Options = .shared

fileprivate struct OptionsPanelBase: View {
    @ObservedObject var _options: Options = options

    private var computerPlayType = Binding<RockPaperScissors.ComputerPlayType>(
        get: { options.computerPlayType },
        set: { options.computerPlayType = $0 }
    )
    
    private var name = Binding<String>(
        get: { options.name ?? "" },
        set: {
            guard $0.count > 0 else {
                options.name = nil
                return
            }
            options.name = $0.trimEnd()
        }
    )
    
    private var gender = Binding<Gender?>(
        get: { options.gender },
        set: { options.gender = $0 }
    )
    
    private var computerPlayHeader: String {
        let localized = t.computerPlayHeader(
            getLocalizedComputerDescription(
                withoutEmoji: true,
                options: options
            )
        )
        return "🎮 \(localized)"
    }
    
    var body: some View {
        Form {
            Section(
                header: Text(computerPlayHeader)
            ) {
                Picker("\(t.playType) 👉",
                       selection: computerPlayType,
                       content: {
                    ForEach(RockPaperScissors.ComputerPlayType.Wrapper.all) {
                                Text($0.type.localizedDescription).tag($0.type)
                            }
                    
                }).pickerStyle(DefaultPickerStyle())
            }
            // ---------- /
            Section(
                header: Text("🧑 \(t.aboutYou)...")
            ) {
                HStack {
                    Text("🗣️ \(t.yourName)")
                    TextField(
                        "nameField",
                        text: name,
                        prompt: Text(t.howToCallYou)
                    ).multilineTextAlignment(.trailing)
                }
                Picker("🚻 \(t.yourGender)",
                       selection: gender,
                       content: {
                            ForEach(Gender.Wrapper.all) {
                                Text($0.gender?.localizedDescription ?? "🚫 \(t.unspecified)").tag($0.gender)
                            }

                }).pickerStyle(DefaultPickerStyle())
            }
        }
    }
}

struct OptionsPanel: View {
    var body: some View {
        #if os(iOS)
            OptionsPanelBase()
                .navigationBarTitle(Text("🎛️ \(t.options)"))
                .navigationBarTitleDisplayMode(.large)
        #else
            OptionsPanelBase()
        #endif
    }
}

struct OptionsPanel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OptionsPanel()
        }
    }
}
