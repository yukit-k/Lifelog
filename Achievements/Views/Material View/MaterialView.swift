//
//  CategoryHome.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct MaterialView: View {
    @EnvironmentObject var startupData: StartupData
    @Environment(\.managedObjectContext) var moc

    @State private var showingProfile = false
    private let topImages = ["mountains-190056", "mountains-2031539"]
    
    var body: some View {
        NavigationView {
            List {
                Image(topImages[startupData.photoIndex])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(Material.Category.allCases) { category in
//                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
//                    CategoryRow(categoryName: key, items: modelData.categories[key]!)
                    CategoryRow(filter: category.rawValue)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(InsetListStyle())
            .navigationTitle("Achievement")
            //.navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile.toggle() }) {
                        Image(systemName: "person.crop.circle")
                            .accessibilityLabel("User Profile")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(startupData)
            }
        }
    }
}

struct Highlight_Previews: PreviewProvider {
    static var previews: some View {
        MaterialView()
            .environmentObject(StartupData())
    }
}
