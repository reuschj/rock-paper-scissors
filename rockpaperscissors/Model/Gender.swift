//
//  Gender.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/6/23.
//

import Foundation

enum Gender: CustomStringConvertible, CaseIterable {
    case male
    case female
    case other
    
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

struct GenderHolder: Identifiable, Hashable {
    let id: UUID = .init()
    let gender: Gender?
    
    init(_ gender: Gender? = nil) {
        self.gender = gender
    }
    
    static let all: [GenderHolder] = [
        .init(),
        .init(.male),
        .init(.female),
        .init(.other)
    ]
}
