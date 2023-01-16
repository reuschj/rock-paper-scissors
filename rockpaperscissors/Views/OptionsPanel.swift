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

fileprivate struct OptionsPanelBase: View {
    @EnvironmentObject var store: Store
    private var options: Options { store.options }
    
    private var name: Binding<String> {
        Binding(
            get: {
                options.name ?? ""
            },
            set: {
                guard $0.count > 0 else {
                    options.name = nil
                    return
                }
                options.name = $0
            }
        )
    }
    
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
                       selection: $store.options.computerPlayType,
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
                       selection: $store.options.gender,
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
                .environmentObject(Store())
        }
    }
}
