//
//  Utils.swift
//  MiniClock
//
//  Created by Wangyiwei on 2022/1/3.
//

import SwiftUI

extension Color {
    static let background = Color(UIColor.systemBackground)
    static func adaptiveGray(_ level: Int) -> Color {
        switch level {
        case 0: return .primary
        case 1: return Color(UIColor.systemGray)
        case 2: return Color(UIColor.systemGray2)
        case 3: return Color(UIColor.systemGray3)
        case 4: return Color(UIColor.systemGray4)
        case 5: return Color(UIColor.systemGray5)
        case 6: return Color(UIColor.systemGray6)
        default: return .background
        }
    }
}
