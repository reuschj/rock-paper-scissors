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
    @StateObject var store: Store = .init()

    var body: some View {
        #if os(iOS)
            IOSMainView()
                .environmentObject(store)
        #else
            MacMainView()
                .environmentObject(store)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
            .environmentObject(Store())
        ContentView()
            .environment(\.locale, .init(identifier: "es"))
            .environmentObject(Store())
        ContentView()
            .environment(\.locale, .init(identifier: "vi"))
            .environmentObject(Store())
        ContentView()
            .environment(\.locale, .init(identifier: "pt-BR"))
            .environmentObject(Store())
    }
}
