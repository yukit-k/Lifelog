//
//  CategoryHome.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI


enum ActiveSheetPictureView: Identifiable {
    case settings, profile
    
    var id: Int {
        hashValue
    }
}

struct PictureView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var moc

    @State private var showingProfile = false
    @State private var activeSheet: ActiveSheetPictureView?
    let imageHelper = ImageHelper()
    
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
                        .frame(height: 200)
                        .listRowInsets(EdgeInsets())
                
                    ForEach(modelData.userSettings.categories) { category in
                        CategoryRow(filter: category)
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
                        SettingHost()
                    case .profile:
                        ProfileSummary()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
            .environmentObject(ModelData())
    }
}
