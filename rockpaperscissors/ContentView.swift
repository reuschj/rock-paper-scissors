//
//  ContentView.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI

private struct OptionsLink: View {
    var body: some View {
        NavigationLink(
            destination: OptionsPanel()
        ) {
            Text("🎛️ \(t.options)")
        }
    }
}

struct IOSMainView: View {
    var body: some View {
        #if os(iOS)
        NavigationStack {
                MainView()
                    .navigationBarItems(
                        trailing: OptionsLink()
                    )
                }
                .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

struct MacMainView: View {
    var body: some View {
        NavigationStack {
            MainView()
        }
    }
}



struct ContentView: View {
    var body: some View {
        #if os(iOS)
            IOSMainView()
        #else
            MacMainView()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
        ContentView()
            .environment(\.locale, .init(identifier: "es"))
        ContentView()
            .environment(\.locale, .init(identifier: "vi"))
        ContentView()
            .environment(\.locale, .init(identifier: "pt-BR"))
    }
}
