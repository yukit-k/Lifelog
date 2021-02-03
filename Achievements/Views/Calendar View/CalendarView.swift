//
//  CalendarView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 31/01/2021.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Sorry! I'm working hard....")
                Image("snowman_nana")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .navigationTitle("Calendar (WIP)")
            }
        }

    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
