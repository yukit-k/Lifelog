//
//  PlusMenu.swift
//  Achievements
//
//  Created by Yuki Takahashi on 10/01/2021.
//

import SwiftUI

struct PlusMenu: View {
    let widthAndHeight: CGFloat
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color("Lavendar"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                VStack {
                    Image(systemName: "text.book.closed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, widthAndHeight/8)
                    Text("Book")
                        .font(.footnote)
                        .padding(.bottom, widthAndHeight/10)
                }
                    .foregroundColor(.white)
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
            ZStack {
                Circle()
                    .foregroundColor(Color("Lavendar"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .shadow(radius: 4)
                VStack {
                    Image(systemName: "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, widthAndHeight/5)
                    Text("Film")
                        .font(.footnote)
                        .padding(.bottom, widthAndHeight/10)
                }
                    .foregroundColor(.white)
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
        }
            .transition(.scale)
    }
}

struct PlusMenu_Previews: PreviewProvider {
    static var previews: some View {
        PlusMenu(widthAndHeight: 80)
    }
}
