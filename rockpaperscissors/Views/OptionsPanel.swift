//
//  OptionsPanel.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/30/22.
//

import SwiftUI
import Combine

fileprivate var options: Options = .shared

fileprivate struct OptionsPanelBase: View {
    @ObservedObject var _options: Options = options

    private var computerPlayType = Binding<ComputerPlayType>(
        get: { options.computerPlayType },
        set: { options.computerPlayType = $0 }
    )
    
    var body: some View {
        Form {
            Section(
                header: Text("How does \(getComputerDescription(withoutEmoji: true)) play?")
            ) {
                Picker("Play type 👉",
                       selection: computerPlayType,
                       content: {
                            ForEach(ComputerPlayTypeHolder.all) {
                                Text($0.type.description).tag($0.type)
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
                .navigationBarTitle(Text("🎛️ Options"))
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
