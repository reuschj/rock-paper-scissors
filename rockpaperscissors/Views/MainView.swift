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
    // 🎚️ State ------------------------------------------ /
    @State var choice: RockPaperScissors? = nil
    @State var opponent: RockPaperScissors? = nil
    @State var result: RockPaperScissors.GameResult? = nil
    @State var resultStringHead: String? = nil
    @State var resultStringSub: String? = nil
    @State var showInstructions: Bool = true
    @State var animating: Bool = false
    @State private var id: UUID = .init()
    
    @ObservedObject var options: Options = .shared
    
    // 📏 Sizes ------------------------------------- /
    
    private let sizes: AppSizes = .standard
    
    private var base: CGFloat { sizes.base }
    private var maxSize: CGFloat { sizes.max }
    
    // 🛠️ Utility ----------------------------------- /
    
    private func getSize(
        from geo: GeometryProxy,
        splitBy items: Int = 3
    ) -> (CGFloat, CGFloat, CGFloat) {
        let fullSize = sizes.cap(within: geo.size.width)
        let gaps = CGFloat(items - 1)
        let spacing = sizes.base(2)
        let allSpacing = spacing * gaps
        let size = (fullSize - allSpacing) / CGFloat(items)
        return (size, fullSize, spacing)
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
    
   // 🏃 Actions ----------------------------------- /
    
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
    
    // 🖼️ Views ----------------------------------- /
    
    // Header area -- /
    
    private func ChoiceHeader(
        within geo: GeometryProxy
    ) -> some View {
        VStack {
            Headline
            ButtonRack(within: geo)
        }
    }

    private var Headline: some View {
        Text("\(t.rockPaperOrScissors)?\n✊✋✌️")
            .font(.title)
            .multilineTextAlignment(.center)
        
    }
    
    private func ButtonRack(
        within geo: GeometryProxy
    ) -> some View {
        let (size, totalSize, spacing) = getSize(from: geo, splitBy: 3)
        return HStack(alignment: .center, spacing: spacing) {
            ChoiceButton(.rock, size: size)
            ChoiceButton(.paper, size: size)
            ChoiceButton(.scissors, size: size)
        }
        .frame(width: totalSize, alignment: .center)
        .padding([.leading, .trailing], spacing)
        .padding(.bottom, spacing * 2)
    }
    
    private func ChoiceButton(
        _ type: RockPaperScissors,
        size: CGFloat
    ) -> some View {
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
    
    // Results area -- /
    
    private func ResultsArea(
        within geo: GeometryProxy
    ) -> some View {
        VStack {
            if !showInstructions, let choice = choice, let opponent = opponent {
                Results(choice, vs: opponent, within: geo)
            } else if showInstructions {
                NoResultPlaceholder
            }
        }
        .id(showInstructions)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut, value: showInstructions)
    }
    
    private func Results(
        _ choice: RockPaperScissors,
        vs opponent: RockPaperScissors,
        within geo: GeometryProxy
    ) -> some View {
        VStack {
            Spacer()
            ResultsHeader
            ResultsBody(choice, vs: opponent, within: geo)
            Spacer()
            ClearButton
            Spacer()
        }
    }
    
    private var NoResultPlaceholder: some View {
        VStack {
            Spacer()
            Text("👆\n\(t.noResultPlaceholder)\n😜")
                .font(.largeTitle)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    private var ResultsHeader: some View {
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
    }
    
    private func ResultsBody(
        _ choice: RockPaperScissors,
        vs opponent: RockPaperScissors,
        within geo: GeometryProxy
    ) -> some View {
        let (blockSize, width, sidePad) = getSize(from: geo, splitBy: 2)
        return HStack(alignment: .center, spacing: sidePad) {
            ResultBlock(
                id: id,
                type: choice,
                result: result,
                label: youLabel,
                size: blockSize,
                isWinner: result == .win,
                fromEdge: .top
            )
            ResultBlock(
                id: id,
                type: opponent,
                result: result,
                label: getLocalizedComputerDescription(options: options),
                size: blockSize,
                isWinner: result == .loss,
                fromEdge: .trailing
            )
        }
        .frame(width: width, alignment: .center)
        .padding([.leading, .trailing], sidePad)
    }
    
    private var ClearButton: some View {
        Button("🧹\(t.clear)") {
            reset()
        }
    }
    
    // 💪 Body ----------------------------------- /
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack(alignment: .center) {
                    ChoiceHeader(within: geo)
                    ResultsArea(within: geo)
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
