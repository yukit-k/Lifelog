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
    @Published var showAddBookSheet: Bool = false
    @Published var showPopup: Bool = false

}

enum Tab {
    case highlight
    case list
    case chart
    case calendar
}

