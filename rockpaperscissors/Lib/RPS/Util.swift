//
//  Util.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 12/29/22.
//

func getComputerPlay(
    vs myChoice: RockPaperScissors,
    type: ComputerPlayType = .random
) -> RockPaperScissors {
    switch type {
    case .random:
        return .random
    case .computerAlwaysWins:
        return RPSResult.win.howToGet(vs: myChoice)
    case .computerAlwaysLoses:
        return RPSResult.loss.howToGet(vs: myChoice)
    case .computerAlwaysMatches:
        return RPSResult.tie.howToGet(vs: myChoice)
    }
}

func getResultString(
    from result: RPSResult,
    _ myChoice: RockPaperScissors,
    vs computer: RockPaperScissors
) -> String {
    let description = myChoice.description(vs: computer)
    switch result {
    case .win: return "\(myChoice) \(description) \(computer)... You win!!! 🎉"
    case .tie: return "Call it a draw! 🤷"
    case .loss: return "\(myChoice) \(description) \(computer)... You lose! 😢"
    }
}
