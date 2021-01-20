//
//  TabBarIcon.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI

struct TabBarIcon: View {
     
    @StateObject var viewRouter: ViewRouter
    let assignedTab: Tab
    let width, height: CGFloat
    let systemIconName, tabName: String
     
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .padding(.horizontal, -4)
            .onTapGesture {
                withAnimation {
                    viewRouter.showPopup.toggle()
                }
                viewRouter.currentTab = assignedTab
            }
            .foregroundColor(viewRouter.currentTab == assignedTab ? .accentColor : .gray)
     }
 }
