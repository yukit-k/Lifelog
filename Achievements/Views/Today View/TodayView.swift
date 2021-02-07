//
//  CalendarView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 31/01/2021.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var modelData: ModelData
    @State private var activeSheet: ActiveSheetNavBar?
    @State private var isFiltered: Bool = false
    @StateObject var filterCategory = CategoryItem()

    let testData = ["Math", "English", "Japanese", "Mummy", "Daddy", "TTR", "IDL"]
    @State private var isCompleted: [Bool]
    
    init() {
        _isCompleted = State(initialValue: Array(repeating: false, count: testData.count))
    }
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    let gridItems = Array(repeating: GridItem(.fixed(geometry.size.width/2), spacing: 0, alignment: .center), count: 2)
                    LazyVGrid(columns: gridItems, alignment: .center, spacing: 10) {
                        ForEach(testData.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.primary, lineWidth: 1)
                                    .background(isCompleted[index] ? Color.blue : Color.white)
                                if isCompleted[index] {
                                    HStack {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                        Text(testData[index])
                                            .foregroundColor(.white)
                                    }
                                } else {
                                    Text(testData[index])
                                }
                            }
                            .frame(height: 100)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                            .onTapGesture {
                                isCompleted[index].toggle()
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Today's To Do")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            activeSheet = .profile
                        }) {
                            Image(systemName: "person.crop.circle")
                                .accessibilityLabel("User Profile")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            activeSheet = .settings
                        }) {
                            if isFiltered == false {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                            } else {
                                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            }
                        }
                    }
                }
                .sheet(item: $activeSheet) {item in
                    switch item {
                    case .settings:
                        CategoryFilterSheet(isFiltered: $isFiltered, filterCategory: filterCategory, userCategory: modelData.userCategory)
                    
                    case .profile:
                        ProfileHost()
                            .environmentObject(modelData)
                    }
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(ModelData())
    }
}
