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
            VStack {
                Text("Sorry! I'm working hard....")
                Image("snowman_nana")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .navigationTitle("Charts (WIP)")
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
