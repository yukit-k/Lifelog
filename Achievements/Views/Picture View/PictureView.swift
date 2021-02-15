//
//  CategoryHome.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct PictureView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var moc

    @State private var showingProfile = false
    @State private var activeSheet: ActiveSheetNavBar?
    let imageHelper = ImageHelper()
    
    @FetchRequest(
        entity: Log.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Log.category, ascending: false)
        ],
        predicate: NSPredicate(format: "isToDo == false")
    ) var logs: FetchedResults<Log>
        
    var body: some View {
        NavigationView {
            GeometryReader { geometry1 in
                List {
                    GeometryReader { geometry2 in
                        Image(modelData.topImages[modelData.photoIndex])
                            .resizable()
                            .scaledToFill()
                            .frame(width:geometry1.size.width, height:imageHelper.getHeightForHeaderImage(geometry2))
                            .clipped()
                            .offset(x: 0, y: imageHelper.getOffsetForHeaderImage(geometry2))
                        }
                        .frame(height: geometry1.size.height/3)
                        .listRowInsets(EdgeInsets())
                    ForEach(group(logs).sorted(), id: \.self) { category in
                        CategoryRow(filter: modelData.userCategory.getCategory(name: category) ?? Category(name: "None", subCategories: []))
//                    ForEach((group(logs)), id: \.self) { (category: [Log]) in
//                        CategoryRow(filter: modelData.userSettings.getCategory(name: category[0].wrappedCategory) ?? Category(name: "None", subCategories: []))
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Achievement")
                .navigationBarTitleDisplayMode(.inline)
                //.navigationBarHidden(true)
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
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .sheet(item: $activeSheet) {item in
                    switch item {
                    case .settings:
                        CategorySettingsHost()
                            .environmentObject(modelData)
                    
                    case .profile:
                        ProfileHost()
                            .environmentObject(modelData)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func group(_ result : FetchedResults<Log>)-> [String] {
            return Dictionary(grouping: result) { $0.category! }
                .map {$0.key}
    }
//    func group(_ result : FetchedResults<Log>)-> [[Log]] {
//
//            return Dictionary(grouping: result) { $0.category! }
//                .sorted(by: {$0.key < $1.key})
//                .map {$0.value}
//    }

}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
            .environmentObject(ModelData())
    }
}
