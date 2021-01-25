//
//  ChartView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 23/01/2021.
//

import SwiftUI

struct ChartView: View {
    var body: some View {
        NavigationView {

            Image("snowman_nana")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .navigationTitle("Chart View")
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
