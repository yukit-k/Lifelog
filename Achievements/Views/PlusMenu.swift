//
//  PlusMenu.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI

struct PlusMenu: View {
    @StateObject var viewRouter: ViewRouter
    @EnvironmentObject var modelData: ModelData
    
    let widthAndHeight: CGFloat
    let cols: Int = 4
    let spacing: CGFloat = 15
    
    var body: some View {
        let gridItems = Array(repeating: GridItem(.fixed(widthAndHeight), spacing: spacing, alignment: .center), count: cols)
//        GeometryReader { geo in
            LazyVGrid(columns: gridItems, alignment: .center, spacing: spacing) {
                ForEach(modelData.userCategory.categories, id: \.self) { category in
                    ZStack {
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: widthAndHeight, height: widthAndHeight)
                            .shadow(radius: 4)
                        VStack {
                            Text(category.icon ?? "")
                                .font(.system(size: widthAndHeight/2))
                            Text(category.name)
                                .font(.system(size: widthAndHeight/7))
                                .padding(.bottom, widthAndHeight/20)
                        }
                            .foregroundColor(.white)
                            .frame(width: widthAndHeight, height: widthAndHeight)
                    }
                    .onTapGesture {
                        viewRouter.showPopup = false
                        viewRouter.category = category
                        viewRouter.showAddSheet = true
                    }
                }
                
    //            ZStack {
    //                Circle()
    //                    .foregroundColor(.accentColor)
    //                    .frame(width: widthAndHeight, height: widthAndHeight)
    //                    .shadow(radius: 4)
    //                VStack {
    //                    Image(systemName: "text.badge.checkmark")
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .padding(.top, widthAndHeight/6)
    //                    Text("Log")
    //                        .font(.footnote)
    //                        .padding(.bottom, widthAndHeight/10)
    //                }
    //                    .foregroundColor(.white)
    //                    .frame(width: widthAndHeight, height: widthAndHeight)
    //            }
    //            .onTapGesture {
    //                viewRouter.showPopup = false
    //                viewRouter.activeSheet = .second
    //                viewRouter.showAddSheet = true
    //            }

//
//            }
        }
//            .offset(x: 0, y: -200)
            
    }
}

struct PlusMenu_Previews: PreviewProvider {
    static var previews: some View {
        PlusMenu(viewRouter: ViewRouter(), widthAndHeight: 70)
            .environmentObject(ModelData())
    }
}
