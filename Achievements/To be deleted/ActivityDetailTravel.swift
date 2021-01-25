//
//  AchievementDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ActivityDetailTravel: View {
    //@EnvironmentObject var modelData: ModelData
    //var landmark: Landmark
    var log: Log
    
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

struct AActivityDetailTravel_Previews: PreviewProvider {
    //static let modelData = ModelData()
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.material?.name = "Test book"
        log1.material?.category = "Book"
        log1.material?.updateDate = Date()
        log1.material?.genre = "Fantasy"
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.recordDate = Date()
        return ActivityDetailTravel(log: log1).environment(\.managedObjectContext, context)

//        AchievementDetail(landmark: ModelData().landmarks[0])
//            .environmentObject(modelData)
    }
}
