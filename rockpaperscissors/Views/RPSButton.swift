//
//  RPSButton.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI

struct RPSButton: View {
    var type: RockPaperScissors = .random
    var size: CGFloat = 128
    var color: Color? = .accentColor
    var showLabel: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            RPSTile(
                type: type,
                size: size,
                color: color,
                opacity: 0.3,
                strokeOpacity: 0.5,
                strokeWidth: 2,
                showLabel: showLabel
            )
        }
            .buttonStyle(PlainButtonStyle())
    }
}

struct RPSButton_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(RPSHolder.all) {
            RPSButton(
                type: $0.type,
                size: 128
            )
                .padding(24)
        }
    }
}
