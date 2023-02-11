//
//  ResultBlock.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/15/23.
//

import SwiftUI
import RockPaperScissorsAPI
import RockPaperScissorsAppAPI

extension MainView {
    struct ResultBlock: View {
        var id: UUID = .init()
        var type: RockPaperScissors = .random
        var result: RockPaperScissors.GameResult? = nil
        var label: String? = nil
        var size: CGFloat
        var isWinner: Bool = false
        var fromEdge: Edge = .leading
        
        var body: some View {
            VStack {
                Tile(type: type, result: result, isWinner: isWinner, size: size)
                    .id(id)
                    .transition(.push(from: fromEdge))
                    .animation(.easeInOut(duration: 0.45), value: id)
                if let label = label {
                    Text(label)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
            }
        }
        
        struct Tile: View {
            var type: RockPaperScissors = .random
            var result: RockPaperScissors.GameResult? = nil
            var isWinner: Bool = false
            var size: CGFloat
            var padEdges: Edge.Set = .bottom
            var padAmount: CGFloat? = AppSizes.standard.base
            
            private var color: Color? {
                guard isWinner else { return nil }
                switch result {
                case .win: return .green
                case .loss: return .red
                default: return nil
                }
            }
            
            var body: some View {
                RPSTile(
                    type: type,
                    size: size,
                    color: color,
                    animateDuration: .seconds(0.5)
                )
                .padding(padEdges, padAmount)
            }
        }
    }
}

struct MainView_ResultBlock_Previews: PreviewProvider {
    static var previews: some View {
        MainView.ResultBlock(
            type: .random,
            result: .win,
            label: "Self winning",
            size: 100,
            isWinner: true,
            fromEdge: .bottom
        )
        MainView.ResultBlock(
            type: .random,
            result: .loss,
            label: "Opponent winning",
            size: 100,
            isWinner: true,
            fromEdge: .bottom
        )
    }
}
