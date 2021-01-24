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
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Log.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Log.recordDate, ascending: false)
    ]) var logs: FetchedResults<Log>
    
    var outstandingLog: [Log] {
        logs.filter { log in
            ((!hideCompletedTasks || log.isToDo) &&
                (searchBar.text.isEmpty ||
                    log.wrappedMaterial.wrappedName.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedMaterial.wrappedDesc.localizedCaseInsensitiveContains(searchBar.text))
            )
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $hideCompletedTasks) {
                    Text("Hide completed tasks")
                }
                ForEach(outstandingLog, id: \.self) { log in
                    ActivityRow(log: log, nextView: ActivityDetailBook(log: log))
                }
                .onDelete(perform: deleteLogs)
            }
            .navigationTitle("Acitivty Log")
            .add(self.searchBar)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func deleteLogs(at offsets: IndexSet) {
        for offset in offsets {
            let log = logs[offset]
            moc.delete(log)
        }
        
        try? moc.save()
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
