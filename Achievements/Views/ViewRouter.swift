//
//  ViewRouter.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentTab: Tab = .highlight

}

enum Tab {
    case highlight
    case list
    case chart
    case calendar
}

