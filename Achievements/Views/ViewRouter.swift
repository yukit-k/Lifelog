//
//  ViewRouter.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI
import Foundation

class ViewRouter: ObservableObject {
    @Published var currentTab: Tab = .highlight
    @Published var showPopup: Bool = false
    @Published var showAddSheet: Bool = false
    @Published var category: Category = Category(name: "Others")
}

enum Tab {
    case highlight
    case list
    case chart
    case calendar
}

enum ActiveSheet {
   case first, second
}
