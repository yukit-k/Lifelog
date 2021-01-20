//
//  AchievementList.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct  AchievementList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var hideCompletedTasks = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommonTask.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \CommonTask.recordDate, ascending: false),
        NSSortDescriptor(keyPath: \CommonTask.title, ascending: true)
    ]) var tasks: FetchedResults<CommonTask>
    

    var filteredTasks: [CommonTask] {
        tasks.filter { task in
            (!hideCompletedTasks || task.status == "Completed")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $hideCompletedTasks) {
                    Text("Hide completed tasks")
                }
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: AchievementDetail(task: task)) {
                        AchievementRow(task: task)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                Button(action: { Text("Search") }) {
                    Image(systemName: "magnifyingglass")
                        .accessibilityLabel("Search")
                }
            }
        }
    }
}

struct  AchievementList_Previews: PreviewProvider {
    
//    static var landmarks = ModelData().landmarks

    static var previews: some View {
        /*
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        */
        AchievementList()
//            .environmentObject(ModelData())
    }
}
