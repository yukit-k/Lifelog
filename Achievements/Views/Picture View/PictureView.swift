//
//  CategoryHome.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI


enum ActiveSheetPictureView: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct PictureView: View {
    @EnvironmentObject var startupData: StartupData
    @Environment(\.managedObjectContext) var moc

    @State private var showingProfile = false
    @State private var activeSheet: ActiveSheetPictureView?
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
            geometry.frame(in: .global).minY
        }
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
            let offset = getScrollOffset(geometry)
            
            // Image was pulled down
            if offset > 0 {
                return -offset
            }
            
            return 0
        }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
    var body: some View {
        NavigationView {
            List {
                Image(startupData.topImages[startupData.photoIndex])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(Log.Category.allCases) { category in
                    CategoryRow(filter: category.rawValue)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Achievement")
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        activeSheet = .second
                    }) {
                        Image(systemName: "person.crop.circle")
                            .accessibilityLabel("User Profile")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        activeSheet = .first
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(item: $activeSheet) {item in
                switch item {
                case .first:
                    SettingHost()
                case .second:
                    ProfileSummary()
                }
            }
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView()
            .environmentObject(StartupData())
    }
}
