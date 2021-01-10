//
//  AchievementList.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct  AchievementList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var showingProfile = false

    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Completed only")
                }
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: AchievementDetail(landmark: landmark)) {
                        AchievementRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Achievement")
            .toolbar {
                Button(action: { showingProfile.toggle() }) {
                    Image(systemName: "magnifyingglass")
                        .accessibilityLabel("Search")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
    }
}

struct  AchievementList_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        /*
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        */
        AchievementList()
            .environmentObject(ModelData())
    }
}
