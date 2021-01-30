//
//  PlusMenu.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI

struct PlusMenu: View {
    @StateObject var viewRouter: ViewRouter
    let widthAndHeight: CGFloat
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                VStack {
                    Image(systemName: "alarm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, widthAndHeight/6)
                    Text("To Do")
                        .font(.footnote)
                        .padding(.bottom, widthAndHeight/10)
                }
                    .foregroundColor(.white)
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
            .onTapGesture {
                viewRouter.showPopup = false
                viewRouter.activeSheet = .first
                viewRouter.showAddSheet = true
            }
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                VStack {
                    Image(systemName: "text.badge.checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, widthAndHeight/6)
                    Text("Log")
                        .font(.footnote)
                        .padding(.bottom, widthAndHeight/10)
                }
                    .foregroundColor(.white)
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
            .onTapGesture {
                viewRouter.showPopup = false
                viewRouter.activeSheet = .second
                viewRouter.showAddSheet = true
            }
        }
            .transition(.scale)
    }
}

struct PlusMenu_Previews: PreviewProvider {
    static var previews: some View {
        PlusMenu(viewRouter: ViewRouter(), widthAndHeight: 80)
    }
}
