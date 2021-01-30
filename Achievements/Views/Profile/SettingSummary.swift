//
//  SettingSummary.swift
//  Achievements
//
//  Created by Yuki Takahashi on 28/01/2021.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var icon: String
}

struct CategoryConfigRow: View {
    var category: Category
    
    var body: some View {
        HStack {
            Text(category.icon)
            Text(category.name)
        }
        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

struct SettingSummary: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            List {
                HStack {
                    Text("Username")
                        .font(.headline)
                        .frame(width: 100)
                    Divider()
                    Text(userSettings.username)
                        .padding(4)
                }
                HStack {
                    Text("Category")
                        .font(.headline)
                        .frame(width: 100)
                    Divider()
                    VStack(alignment: .leading) {
                        ForEach(userSettings.categories, id: \.self) { category in
                            CategoryConfigRow(category: category)
                                .padding(4)
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        userSettings.categories.remove(atOffsets: offsets)
    }
    func move(from source: IndexSet, to destination: Int) {
        userSettings.categories.move(fromOffsets: source, toOffset: destination)
    }
}

struct SettingSummary_Previews: PreviewProvider {
    static var previews: some View {
        SettingSummary()
    }
}
