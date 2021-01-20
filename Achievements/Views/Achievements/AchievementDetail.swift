//
//  AchievementDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct AchievementDetail: View {
    //@EnvironmentObject var modelData: ModelData
    //var landmark: Landmark
    var task: CommonTask
    
//    var landmarkIndex: Int {
//        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
//    }
    
    var body: some View {
        ScrollView {
//            MapView(coordinate: landmark.locationCoordinate)
//                .frame(height: 300)
//
//            CircleImage(image: landmark.image)
//                .offset(y: -130)
//                .padding(.bottom, -130)
//
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(landmark.name)
//                        .font(.title)
//                        .foregroundColor(.primary)
//                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
//                }
//
//                HStack {
//                    Text(landmark.park)
//                    Spacer()
//                    Text(landmark.state)
//
//                }
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//
//                Divider()
//
//                Text("About \(landmark.name)")
//                    .font(.title2)
//                Text(landmark.description)
//
//          }
//            .padding()
//
//        }
//        .navigationTitle(landmark.name)
//        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AchievementDetail_Previews: PreviewProvider {
    //static let modelData = ModelData()
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let bookTest = CommonTask(context: context)
        bookTest.title = "Test book"
        bookTest.shortDesc = "Some interesting book."
        bookTest.genre = "Fantasy"
        bookTest.rating = 4
        bookTest.comment = "This was a great book"
        bookTest.recordDate = Date()
        return AchievementDetail(task: bookTest).environment(\.managedObjectContext, context)

//        AchievementDetail(landmark: ModelData().landmarks[0])
//            .environmentObject(modelData)
    }
}
