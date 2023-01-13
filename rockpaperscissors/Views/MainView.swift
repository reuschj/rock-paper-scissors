//
//  MainView.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

import SwiftUI
import Combine
import RockPaperScissorsAPI
import RockPaperScissorsAppAPI

struct MainView: View {
    @State var choice: RockPaperScissors? = nil
    @State var opponent: RockPaperScissors? = nil
    @State var result: RockPaperScissors.GameResult? = nil
    @State var resultStringHead: String? = nil
    @State var resultStringSub: String? = nil
    @State var showInstructions: Bool = true
    @State var animating: Bool = false
    @State private var id: UUID = .init()
    
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
        self.id = .init()
        self.showInstructions = false
        self.choice = choice
        let opponent = getComputerPlay(
            vs: choice,
            type: options.computerPlayType
        )
        self.opponent = opponent
        let result: RockPaperScissors.GameResult = .from(choice, vs: opponent)
        self.result = result
        self.resultStringSub = choice.localizedDescription(vs: opponent)
        switch result {
        case .win:
            self.resultStringHead = "\(t.winMessage)! 🎉🥳🍾"
        case .tie:
            self.resultStringHead = "\(t.tieMessage) \(shrugEmoji)"
        case .loss:
            self.resultStringHead = "\(t.lossMessage) 😢😭"
        }
    }
    
    private func reset(showInstructions: Bool = true, choice: RockPaperScissors? = nil) {
        self.id = .init()
        self.showInstructions = showInstructions
        self.choice = choice
        self.opponent = nil
        self.result = nil
        self.resultStringHead = nil
        self.resultStringSub = nil
    }
    
    private func animate(for duration: Duration, sideEffect: (() -> Void)? = nil) {
        self.animating = true
        Task {
            try await Task.sleep(for: duration)
            sideEffect?()
            self.animating = false
        }
    }
    
    private func button(_ type: RockPaperScissors, size: CGFloat) -> some View {
        VStack {
            RPSButton(
                type: type,
                size: size,
                color: choice == type ? .yellow : .teal
            )  {
                makeChoice(type)
                animate(for: .seconds(0.4))
            }
        }
        .scaleEffect(choice == type ? (animating ? 1.15 : 1) : (animating ? 0.85 : 1))
        .animation(.default, value: animating)
    }
    
    private func tile(_ type: RockPaperScissors, size: CGFloat, didWin: Bool) -> some View {
        RPSTile(
            type: type,
            size: size,
            color: didWin ? (result == .win ? .green : .red) : nil,
            animateDuration: .seconds(0.5)
        )
        .padding(.bottom, base)
    }
    
    private func resultBlock(_ type: RockPaperScissors, label: String, size: CGFloat, didWin: Bool, from edge: Edge = .leading) -> some View {
        VStack {
            tile(
                type,
                size: size,
                didWin: didWin
            )
                .id(id)
                .transition(.push(from: edge))
                .animation(.easeInOut(duration: 0.45), value: id)
            Text(label)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }
    
    private var headline: some View {
        Text("\(t.rockPaperOrScissors)?\n✊✋✌️")
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
    
    private var youName: String { options.name ?? t.you }
    
    private var youEmoji: Character {
        switch options.gender {
        case .male:
            return "🧍‍♂️"
        case .female:
            return "🧍‍♀️"
        default:
            return "🧍"
        }
    }
    
    private var youLabel: String { "\(youName)\(youEmoji)" }
    
    private var shrugEmoji: Character {
        switch options.gender {
        case .male:
            return "🤷‍♂️"
        case .female:
            return "🤷‍♀️"
        default:
            return "🤷"
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack(alignment: .center) {
                    VStack {
                        headline
                        buttonRack(within: geo)
                    }
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
                                .id(animating)
                                .opacity(animating ? 0 : 1)
                                .animation(.easeInOut, value: animating)
                                
                                HStack(alignment: .center, spacing: resultSpacing) {
                                    resultBlock(
                                        choice,
                                        label: youLabel,
                                        size: resultSize,
                                        didWin: result == .win,
                                        from: .top
                                    )
                                    resultBlock(
                                        opponent,
                                        label: getLocalizedComputerDescription(options: options),
                                        size: resultSize,
                                        didWin: result == .loss,
                                        from: .trailing
                                    )
                                }
                                .frame(width: totalResultSize, alignment: .center)
                                .padding([.leading, .trailing], resultSpacing)
                                
                                Spacer()
                                Button("🧹\(t.clear)") {
                                    reset()
                                }
                                Spacer()
                            }
                        } else if showInstructions {
                            VStack {
                                Spacer()
                                Text("👆\n\(t.noResultPlaceholder)\n😜")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                        }
                    }
                    .id(showInstructions)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showInstructions)
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
