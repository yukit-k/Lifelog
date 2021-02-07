//
//  CircleCount.swift
//  Achievements
//
//  Created by Yuki Takahashi on 05/02/2021.
//

import SwiftUI

struct CircleCount: View {
    var title: LocalizedStringKey?
    var count: Int
    var width: CGFloat
    var color: Color = Color.accentColor
    var body: some View {
        VStack {
            if title != nil {
                Text(title!)
                    .font(width > 100 ? .headline : .subheadline)
                    .frame(width: width)
                    .multilineTextAlignment(.center)
            }
            ZStack {
                Circle()
                    .foregroundColor(color)
                    .frame(width: width*0.95, height: width*0.95)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: width*0.9, height: width*0.9)
                Circle()
                    .foregroundColor(color)
                    .frame(width: width*0.85, height: width*0.85)
                Circle()
                    .foregroundColor(.white)
                    .frame(width: width*0.75, height: width*0.75)
                Text("\(count)")
                    .font(.system(size: count < 10 ? width*0.6 : count < 100 ? width*0.45 : width*0.3))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(color)
            }
        }
        
    }
}

struct CircleCount_Previews: PreviewProvider {
    static var previews: some View {
        CircleCount(title: "Test", count: 123, width: 90, color: .blue)
    }
}
