//
//  AppSizes.swift
//  rockpaperscissors
//
//  Created by Justin Reusch on 1/15/23.
//

import Foundation

struct AppSizes {
    var base: CGFloat
    var max: CGFloat
    
    public func base(_ multiplier: CGFloat) -> CGFloat {
        base * multiplier
    }
    
    public func cap(within size: CGFloat) -> CGFloat {
        min(max, size)
    }
    
    public static let standard: Self = .init(base: 8, max: 560)
}
