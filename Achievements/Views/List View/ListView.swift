//
//  AchievementList.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct  ListView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var categoryFilter: CategoryFilter
    @State private var viewMode: String = "all"
    @StateObject var searchBar: SearchBar = SearchBar()
    @State private var showingOptionView: Bool = false
    @State private var activeSheet: ActiveSheetNavBar?
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Log.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Log.activityDate, ascending: false)
    ]) var logs: FetchedResults<Log>
    
    var filteredLog: [Log] {
        categoryFilter.filterLogs(logs).filter { log in
            (!(log.isRoutine && log.isToDo) &&
                (viewMode == "all" || viewMode == "todo" && log.isToDo || viewMode == "done" && !log.isToDo) &&
                (searchBar.text.isEmpty ||
                    log.wrappedName.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedDesc.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedCategory.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedSubCategory.localizedCaseInsensitiveContains(searchBar.text)
                )
            )
        }
    }
    var routineLog: [Log] {
        categoryFilter.filterLogs(logs).filter { log in
            ((log.isRoutine && log.isToDo) &&
                (viewMode == "all" || viewMode == "todo" && log.isToDo || viewMode == "done" && !log.isToDo) &&
                (searchBar.text.isEmpty ||
                    log.wrappedName.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedDesc.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedCategory.localizedCaseInsensitiveContains(searchBar.text) ||
                    log.wrappedSubCategory.localizedCaseInsensitiveContains(searchBar.text)
                )
            )
        }
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    func groupByDate(_ result : [Log])-> [[Log]]{
        return  Dictionary(grouping: result){ (element : Log)  in
            dateFormatter.string(from: element.activityDate!)
        }.values.sorted() { $0[0].activityDate! > $1[0].activityDate! }
    }

    var body: some View {
        NavigationView {
                List {
                    if categoryFilter.isFiltered {
                        HStack {
                            Text("Applied Fileter: \(categoryFilter.category.icon ?? "")\(categoryFilter.category.name)")
                            if categoryFilter.subCategory.name != "" {
                                Divider()
                                Text("\(categoryFilter.subCategory.icon ?? "")\(categoryFilter.subCategory.name)")
                            }
                        }
                        .padding(5)
                    }
                    Picker("Filter", selection: $viewMode) {
                        Text("All").tag("all")
                        Text("To Do").tag("todo")
                        Text("Done").tag("done")
                    }
                    .pickerStyle(SegmentedPickerStyle())
    //                ForEach(filteredLog, id: \.self) { log in
    //                    ActivityRow(log: log, nextView: ActivityDetail(log: log))
    //                }
                    ForEach(groupByDate(filteredLog), id:\.self) { (section: [Log]) in
                        Section(header: Text( self.dateFormatter.string(from: section[0].activityDate!))) {
                            ForEach(section, id: \.self) { log in
                                HStack {
                                    ActivityRow(log: log, nextView: ActivityDetail(log: log))
                                }
                            }
                            .onDelete(perform: deleteLogs)
                        }
                    }
                    //.id(filteredLog.count)
                    if routineLog.count > 0 {
                        Section(header: Text("Daily Routine")) {
                            ForEach(routineLog, id: \.self) { log in
                                ActivityRow(log: log, nextView: ActivityDetail(log: log))
                            }
                            .onDelete(perform: deleteLogs)
                        }
                    }
                }
                .navigationBarTitle("Activity Log")
                .navigationBarTitleDisplayMode(.inline)
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
                            if categoryFilter.isFiltered == false {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                            } else {
                                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
                .sheet(item: $activeSheet) {item in
                    switch item {
                    case .settings:
                        CategoryFilterSheet()
                    case .profile:
                        ProfileHost()
                            .environmentObject(modelData)
                }
                
            }
            .add(self.searchBar)
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
