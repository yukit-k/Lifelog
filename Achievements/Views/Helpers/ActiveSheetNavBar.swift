//
//  ActiveSheetNavBar.swift
//  Achievements
//
//  Created by Yuki Takahashi on 06/02/2021.
//

import SwiftUI

enum ActiveSheetNavBar: Identifiable {
    case settings, profile
    
    var id: Int {
        hashValue
    }
}
