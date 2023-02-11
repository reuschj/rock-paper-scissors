//
//  Gender.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/6/23.
//

import Foundation
import RockPaperScissorsAppAPI

enum Gender: String, RawRepresentable, CaseIterable {
    /// Identifying as male
    case male
    /// Identifying as female
    case female
    /// Identifying as anything else than the above
    case other
}

extension Gender: CustomStringConvertible {
    var description: String {
        switch self {
        case .male:
            return "🚹 Male"
        case .female:
            return "🚺 Female"
        case .other:
            return "⚧️ Other"
        }
    }
}

extension Gender: CustomLocalizedStringConvertible {
    var localizedDescription: String {
        switch self {
        case .male:
            return "🚹 \(t.male)"
        case .female:
            return "🚺 \(t.female)"
        case .other:
            return "⚧️ \(t.other)"
        }
    }
}

extension Gender {
    // 🎁 Wrapper -------------------------------- /

    /// A box wrapping a gender value with a unique ID.
    public struct Wrapper: Identifiable, Hashable {
        public let gender: Gender?
        public let id: UUID = .init()
        
        public init(around gender: Gender? = nil) {
            self.gender = gender
        }
        
        public static let all: [Wrapper] = [
            .init(),
            .init(around: .male),
            .init(around: .female),
            .init(around: .other)
        ]
    }
}
