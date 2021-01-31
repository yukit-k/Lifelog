//
//  AchievementList.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct  ListView: View {
    //@EnvironmentObject var modelData: ModelData
    @State private var viewMode: String = "all"
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @State private var showingOptionView: Bool = false
    @State private var activeSheet: ActiveSheetPictureView?

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Log.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Log.activityDate, ascending: false)
    ]) var logs: FetchedResults<Log>
    
    var outstandingLog: [Log] {
        logs.filter { log in
            ((viewMode == "all" || viewMode == "todo" && log.isToDo || viewMode == "done" && !log.isToDo) &&
                (searchBar.text.isEmpty ||
                    log.wrappedName.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedDesc.localizedCaseInsensitiveContains(searchBar.text))
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
                dateFormatter.string(from: element.activityDate!)
          }.values.map{$0}
    }

    var body: some View {
        NavigationView {
            List {
                Picker("Filter", selection: $viewMode) {
                    Text("All").tag("all")
                    Text("To Do").tag("todo")
                    Text("Done").tag("done")
                }
                .pickerStyle(SegmentedPickerStyle())
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
                .navigationBarTitle("Acitivty Log")
                .navigationBarTitleDisplayMode(.inline)
                .add(self.searchBar)
//                .navigationBarItems(trailing: EditButton())
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func moveLogs(source: IndexSet, destination: Int) {
        
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

struct  ListView_Previews: PreviewProvider {
    
    static var previews: some View {
        /*
        ForEach(["iPhone SE", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        */
        ListView()
    }
}
