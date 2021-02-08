//
//  CalendarView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 31/01/2021.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var modelData: ModelData
    @State private var activeSheet: ActiveSheetNavBar?
    @State private var isFiltered: Bool = false
    @StateObject var filterCategory = CategoryItem()
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
    }
    
    @FetchRequest(entity: Log.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Log.category, ascending: true),
                    NSSortDescriptor(keyPath: \Log.subCategory, ascending: true),
                    NSSortDescriptor(keyPath: \Log.name, ascending: true)
                  ],
                  predicate: NSCompoundPredicate(type: .and, subpredicates: [
                      NSPredicate(format: "activityDate <= %@", Date() as CVarArg),
                      NSPredicate(format: "isRoutine == true")
                  ])) var routineLogs: FetchedResults<Log>
    
//    @FetchRequest var fetchRequestRoutine: FetchedResults
    //@FetchRequest var filteredRoutineDone: FetchedResults
//    init() {
//        self._fetchRequestRoutine = FetchRequest(
//            Entity: Log.entity(),
//        )
//    }

//    var fetchRequestRoutine = FetchRequest<Log>(entity: Log.entity(),
//                        sortDescriptors: [],
//                        predicate: NSCompoundPredicate(type: .and, subpredicates: [
//                            NSPredicate(format: "activityDate <= %@", Date() as CVarArg),
//                            NSPredicate(format: "isRoutine == true")
//                        ])
//    )
//    var routineLogs: FetchedResults<Log> { fetchRequestRoutine.wrappedValue }

    var filteredRoutineTodo: [Log] {
        routineLogs.filter { log in
            (log.isToDo) &&
            ((isFiltered == false) ||
                (isFiltered == true && log.wrappedCategory == filterCategory.category.name)
            )
        }
    }
    var filteredRoutineDone: [Log] {
        routineLogs.filter { log in
            (!log.isToDo && dateFormatter.string(from: log.wrappedActivityDate) == dateFormatter.string(from: Date())) &&
            ((isFiltered == false) ||
                (isFiltered == true && log.wrappedCategory == filterCategory.category.name)
            )
        }
    }

    @FetchRequest(entity: Log.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \Log.name, ascending: true)
                  ],
                  predicate: NSCompoundPredicate(type: .and, subpredicates: [
                      NSPredicate(format: "activityDate >= %@", Date().addingTimeInterval(-60*60*24*2) as CVarArg),
                      NSPredicate(format: "isRoutine == false")
                  ])) var adhocLogs: FetchedResults<Log>

    var filteredAdhocLogs: [Log] {
        adhocLogs.filter { log in
            let activityDate = dateFormatter.string(from: log.wrappedActivityDate)
            let today = dateFormatter.string(from: Date())
            return (activityDate == today) &&
                (isFiltered == false ||
                    isFiltered == true && log.wrappedCategory == filterCategory.category.name
                )
        }
    }
    
    @State var stateRoutineTodo = [Log]()
    @State var stateRoutineDone = [Log]()
    @State var stateAdhocLogs = [Log]()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    if isFiltered {
                        Text("Applied Fileter: \(filterCategory.category.icon ?? "")\(filterCategory.category.name)")
                            .padding(.top, 20)
                            .padding(.bottom, 0)
                    }
                    let gridItems = Array(repeating: GridItem(.fixed(geometry.size.width/2), spacing: 0, alignment: .center), count: 2)
                    Section(header: Text("Daily Routine").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(.top, 10)) {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 10) {
                            ForEach(Array(stateRoutineTodo.enumerated()), id: \.1.id) { index, log in
                                TodayTaskItemView(log: log, isCompleted: stateRoutineDone.firstIndex(where: {$0.routineLogId == log.id}) != nil)
//                                    .frame(height: 80)
                                    .padding(.horizontal, 10)
                                    .padding(.top, 10)
                                    .onTapGesture {
                                        if (stateRoutineDone.firstIndex(where: {$0.routineLogId == log.id}) != nil) {
                                            self.delete(log: log)
                                        } else {
                                            self.add(log: log)
                                        }
                                    }
                            }
                        }
                    }
                    Divider()
                    Section(header: Text("Specific for Today").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(.top, 10)) {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 10) {
                            ForEach(Array(filteredAdhocLogs.enumerated()), id: \.1.id) { index, log in
                                TodayTaskItemView(log: log, isCompleted: !log.isToDo)
//                                    .frame(height: 80)
                                    .padding(.horizontal, 10)
                                    .padding(.top, 10)
                                    .onTapGesture {
                                        self.update(log: log)
                                    }
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Today's To Do (\(Date(), formatter: self.dateFormatter))")
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
                            if isFiltered == false {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                            } else {
                                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            }
                        }
                    }
                }
                .sheet(item: $activeSheet) {item in
                    switch item {
                    case .settings:
                        CategoryFilterSheet(isFiltered: $isFiltered, filterCategory: filterCategory, userCategory: modelData.userCategory)
                            .onDisappear {
                                self.stateRoutineTodo = filteredRoutineTodo
                                self.stateRoutineDone = filteredRoutineDone
                                self.stateAdhocLogs = filteredAdhocLogs
                            }
                    
                    case .profile:
                        ProfileHost()
                            .environmentObject(modelData)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .onAppear {
            self.stateRoutineTodo = filteredRoutineTodo
            self.stateRoutineDone = filteredRoutineDone
            self.stateAdhocLogs = filteredAdhocLogs
        }
    }
    
    func add(log: Log) {
        let newLog = Log(context: self.moc)
        newLog.id = UUID()
        newLog.isToDo = false
        newLog.isRoutine = true
        newLog.routineLogId = log.id
        newLog.category = log.category
        newLog.categoryIcon = log.categoryIcon
        newLog.name = log.name
        newLog.activityDate = Date()
        newLog.rating = Int16(3)
//        newLog.comment = ""
        newLog.subCategory = log.subCategory
        newLog.subCategoryIcon = log.subCategoryIcon
        newLog.creator = log.creator
        newLog.desc = log.desc
        newLog.amount = log.amount
        newLog.unit = log.unit
        newLog.updatedDate = Date()
        newLog.status = "Worked"
        newLog.image = log.image
        stateRoutineDone.append(newLog)
        
        if self.moc.hasChanges {
            do {
                try self.moc.save()
                print("New Log: \(log.wrappedName) added.")
                
            } catch {
                print(error)
            }
        }

    }
    
    func delete(log: Log) {
        let index = stateRoutineDone.firstIndex(where: {$0.routineLogId == log.id})
        let log = stateRoutineDone.first(where: {$0.routineLogId == log.id})
        if log != nil {
            print("Deleting a log...")
            stateRoutineDone.remove(at: index!)
            moc.delete(log!)
        } else {
            print("Cannot find the log to delete...")
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
    
    func update(log: Log) {
        if log.isToDo {
            log.isToDo = false
        } else {
            log.isToDo = true
        }
        
        if self.moc.hasChanges {
            do {
                try self.moc.save()
                print("Log: \(log.name!) updated to \(log.isToDo).")
            } catch {
                print(error)
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(ModelData())
    }
}
