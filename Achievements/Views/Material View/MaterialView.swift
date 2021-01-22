//
//  CategoryHome.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct MaterialView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(entity: Material.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Material.updateDate, ascending: false)
//    ]) var materials: FetchedResults<Material>

    @State private var showingProfile = false
    private let topImages = [
        "silversalmoncreek",
        "chilkoottrail",
        "stmarylake",
        "twinlake",
        "lakemcdonald",
        "charleyrivers",
        "icybay",
        "rainbowlake",
        "hiddenlake",
        "chincoteague",
        "umbagog"
    ]
    //private let imageIndex = Int.random(in: 0..<11)
    
    var body: some View {
        NavigationView {
            List {
                Image(topImages[4])
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
            .navigationTitle("Materaials")
            //.navigationBarHidden(true)
            .toolbar {
                Button(action: { showingProfile.toggle() }) {
                    Image(systemName: "person.crop.circle")
                        .accessibilityLabel("User Profile")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
    }
}

struct Highlight_Previews: PreviewProvider {
    static var previews: some View {
        MaterialView()
            .environmentObject(ModelData())
    }
}
