//
//  RPSTile.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI
import RockPaperScissorsAPI
import RockPaperScissorsAppAPI

struct RPSTile: View {
    var type: RockPaperScissors = .random
    var size: CGFloat = 128
    var maxSize: CGFloat = 256
    var color: Color? = nil
    var opacity: CGFloat = 0.2
    var strokeOpacity: CGFloat = 0.5
    var strokeWidth: CGFloat = 1
    var showLabel: Bool = false
    var animateDuration: Duration? = nil
    
    @State private var animating: Bool = true

    private let multiplier: CGFloat = 16
    private var _size: CGFloat { min(size, maxSize) }
    private var base: CGFloat { _size / multiplier }
    private var cornerRadius: CGFloat { base }
    
    private func animate() {
        animating = true
        Task {
            try await Task.sleep(for: animateDuration ?? .seconds(1))
            animating = false
        }
    }

    var body: some View {
        VStack {
            Text(String(type.emoji))
                .font(Font.custom("Emoji",
                    size: _size - (base * 4)
                ))
                .frame(alignment: .center)
                .padding(base)
            if showLabel {
                Text(type.text.uppercased())
                    .font(.caption)
                    .foregroundColor(color ?? .primary)
            }
        }
            .padding(base)
            .background(
                ( color ?? .clear )
                    .opacity(animateDuration != nil && animating ? 0 : opacity)
                    .animation(.easeInOut, value: animating)
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color ?? .clear,
                        lineWidth: strokeWidth
                    )
                    .opacity(animateDuration != nil && animating ? 0 : strokeOpacity)
                    .animation(.easeInOut, value: animating)
            )
            .frame(minWidth: _size, maxWidth: _size, minHeight: _size, maxHeight: _size)
            .onAppear { animate() }
    }
}

struct RPSTile_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(RockPaperScissors.Wrapper.all) {
            RPSTile(
                type: $0.type,
                size: 128,
                color: .blue,
                opacity: 0.5,
                strokeOpacity: 0.2,
                strokeWidth: 1,
                showLabel: false,
                animateDuration: .seconds(0.5)
            )
                .padding(24)
        }
    }
}
