//
//  MainView.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI
import Combine

struct MainView: View {
    @State var choice: RockPaperScissors? = nil
    @State var opponent: RockPaperScissors? = nil
    @State var result: RPSResult? = nil
    @State var resultStringHead: String? = nil
    @State var resultStringSub: String? = nil
    @State var showInstructions: Bool = true
    @State var animating: Bool = false
    
    @ObservedObject var options: Options = .shared
    
    private let base: CGFloat = 8
    private let maxSize: CGFloat = 560

    private func getSize(
        from geo: GeometryProxy,
        items: Int = 3
    ) -> (CGFloat, CGFloat, CGFloat) {
        let fullSize = min(maxSize, geo.size.width)
        let gaps = CGFloat(items - 1)
        let spacing = base * 2
        let allSpacing = spacing * gaps
        let size = (fullSize - allSpacing) / CGFloat(items)
        return (size, fullSize, spacing)
    }
    
    private func makeChoice(_ choice: RockPaperScissors) {
        self.showInstructions = false
        self.choice = choice
        let opponent = getComputerPlay(
            vs: choice,
            type: options.computerPlayType
        )
        self.opponent = opponent
        let result: RPSResult = .from(choice, vs: opponent)
        self.result = result
        self.resultStringSub = "\(choice.text.capitalized) \(choice.description(vs: opponent)) \(opponent.text)."
        switch result {
        case .win:
            self.resultStringHead = "You won! 🎉🥳🍾"
        case .tie:
            self.resultStringHead = "Call it a draw 🤷"
        case .loss:
            self.resultStringHead = "You lost! 😢😭"
        }
    }
    
    private func reset(showInstructions: Bool = true, choice: RockPaperScissors? = nil) {
        self.showInstructions = showInstructions
        self.choice = choice
        self.opponent = nil
        self.result = nil
        self.resultStringHead = nil
        self.resultStringSub = nil
    }
    
    private func button(_ type: RockPaperScissors, size: CGFloat) -> some View {
        VStack {
            RPSButton(
                type: type,
                size: size,
                color: choice == type ? .yellow : .teal
            )  {
                self.animating = true
//                makeChoice(type)
                reset(showInstructions: false, choice: type)
                Task {
                    try await Task.sleep(for: .seconds(0.4))
                    makeChoice(type)
                    self.animating = false
                }
            }
        }
        .scaleEffect(choice == type ? (animating ? 1.1 : 1) : (animating ? 0.9 : 1))
        .animation(.default, value: animating)
    }
    
    private func tile(_ type: RockPaperScissors, size: CGFloat, didWin: Bool) -> some View {
        RPSTile(
            type: type,
            size: size,
            color: didWin ? (result == .win ? .green : .red) : nil
        )
        .padding(.top, base)
    }
    
    private func resultBlock(_ type: RockPaperScissors, label: String, size: CGFloat, didWin: Bool) -> some View {
        VStack {
            Text(label)
                .font(.headline)
            tile(
                type,
                size: size,
                didWin: didWin
            )
        }
    }
    
    private var headline: some View {
        Text("Rock, Paper or Scissors?\n✊✋✌️")
            .font(.title)
            .multilineTextAlignment(.center)
        
    }
    
    private func buttonRack(within geo: GeometryProxy) -> some View {
        let (size, totalSize, spacing) = getSize(from: geo, items: 3)
        return HStack(alignment: .center, spacing: spacing) {
            button(.rock, size: size)
            button(.paper, size: size)
            button(.scissors, size: size)
        }
            .frame(width: totalSize, alignment: .center)
            .padding([.leading, .trailing], spacing)
            .padding(.bottom, spacing * 2)
    }
    
    var body: some View {
        VStack {
            headline
            GeometryReader { geo in
                
                VStack(alignment: .center) {
                    buttonRack(within: geo)
                    
                    VStack {
                        if !showInstructions, let choice = choice, let opponent = opponent {
                            let (resultSize, totalResultSize, resultSpacing) = getSize(from: geo, items: 2)
                            VStack {
                                Spacer()
                                VStack {
                                    if let head = resultStringHead {
                                        Text(head)
                                            .font(.largeTitle)
                                            .foregroundColor(result == .loss ? .red : .primary)
                                    }
                                    if let sub = resultStringSub {
                                        Text(sub)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.bottom)
                                HStack(alignment: .center, spacing: resultSpacing) {
                                    resultBlock(
                                        choice,
                                        label: "You🧍",
                                        size: resultSize,
                                        didWin: result == .win
                                    )
                                    resultBlock(
                                        opponent,
                                        label: getComputerDescription(),
                                        size: resultSize,
                                        didWin: result == .loss
                                    )
                                }
                                .frame(width: totalResultSize, alignment: .center)
                                .padding([.leading, .trailing], resultSpacing)
                                
                                Spacer()
                                Button("🧹Clear") {
                                    reset()
                                }
                                Spacer()
                            }
                            .transition(.slide)
                            .animation(.easeInOut)
                        } else if showInstructions {
                            VStack {
                                Spacer()
                                Text("👆\nPress a button above to get a result!\n😜")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .transition(.slide)
                            .animation(.easeInOut)
                        }
                    }
                }
                .frame(width: geo.size.width)
            }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
