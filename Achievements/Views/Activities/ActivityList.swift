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
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    func update(_ result : [Log])-> [[Log]]{
          return  Dictionary(grouping: result){ (element : Log)  in
                dateFormatter.string(from: element.recordDate!)
          }.values.map{$0}
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $hideCompletedTasks) {
                    Text("Hide completed tasks")
                }
                ForEach(outstandingLog, id: \.self) { log in
                    ActivityRow(log: log, nextView: ActivityDetail(log: log))
                }
                    .onDelete(perform: deleteLogs)
//                ForEach(update(outstandingLog), id: \.self) { (section: [Log]) in
//                    Section(header: Text(self.dateFormatter.string(from: section[0].recordDate!))) {
//                        ForEach(section, id: \.self) { log in
//                            ActivityRow(log: log, nextView: ActivityDetailBook(log: log))
//                        }
//                        .onDelete(perform: deleteLogs)
//                    }
//                }
//                    .id(outstandingLog.count)
            }
                .navigationTitle("Acitivty Log")
                .add(self.searchBar)
                .navigationBarItems(trailing: EditButton())
        }
    }
    
    func deleteLogs(at offsets: IndexSet) {
        for offset in offsets {
            let log = logs[offset]
            print("Deleting a log...")
            moc.delete(log)
        }
        
        if self.moc.hasChanges {
            do {
                try self.moc.save()
                print("Delete Log Completed.")
            } catch {
                print(error)
            }
        }
    }
}

struct  ActivityList_Previews: PreviewProvider {
    
    static var previews: some View {
        /*
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        */
        ActivityList()
    }
}
