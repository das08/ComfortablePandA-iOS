//
//  BadgeCount.swift
//  ComfortablePandA
//
//  Created by das08 on 2020/10/20.
//

import SwiftUI

class BadgeCount {
    static let shared = BadgeCount()
    
    @AppStorage("badgeCount", store: UserDefaults(suiteName: "group.com.das08.ComfortablePandA"))
    var badgeCount: Int = 0
}
