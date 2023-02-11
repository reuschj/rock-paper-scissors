//
//  Store.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/28/23.
//

import Foundation

class Store: ObservableObject {
    @Published var options: Options = .shared
}
