//
//  AchievementList.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct  ActivityList: View {
    //@EnvironmentObject var modelData: ModelData
    @State private var hideCompletedTasks = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Log.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Log.recordDate, ascending: false)
    ]) var logs: FetchedResults<Log>
    
    var outstandingLog: [Log] {
        logs.filter { log in
            (!hideCompletedTasks || log.status != "Completed")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $hideCompletedTasks) {
                    Text("Hide completed tasks")
                }
                ForEach(outstandingLog) { log in
                    NavigationLink(destination: ActivityDetail(log: log)) {
                        ActivityRow(log: log)
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

struct  ActivityList_Previews: PreviewProvider {
    
//    static var landmarks = ModelData().landmarks

    static var previews: some View {
        /*
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        */
        ActivityList()
//            .environmentObject(ModelData())
    }
}
