//
//  ChartView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 23/01/2021.
//

import SwiftUI
import CoreData

//struct FilteredList<T: NSManagedObject, Content: View>: View {
//    var fetchRequest: FetchRequest<T>
//    var items: FetchedResults<T> { fetchRequest.wrappedValue }
//
//    // this is our content closure; we'll call this once for each item in the list
//    let content: (T) -> Content
//
//    var body: some View {
//        List(fetchRequest.wrappedValue, id: \.self) { item in
//            self.content(item)
//        }
//    }
//
//    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
//        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
//        self.content = content
//    }
//}

struct ChartView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var modelData: ModelData
    @State private var activeSheet: ActiveSheetNavBar?
    
    @State private var isFiltered: Bool = false
    @StateObject var filterCategory = CategoryItem()
    
    func filter(_ logs: FetchedResults<Log>) -> [Log] {
        logs.filter { log in
            (isFiltered == false ||
                isFiltered == true && log.wrappedCategory == filterCategory.category.name
            )
        }
    }
    /* Today and Yesterday Part*/
    @FetchRequest(entity: Log.entity(),
                  sortDescriptors: [],
                  predicate: NSCompoundPredicate(type: .or, subpredicates: [
                      NSPredicate(format: "activityDate >= %@", Date().addingTimeInterval(-60*60*24*2) as CVarArg),
                      NSPredicate(format: "NOT (isRoutine == true AND isToDo == true)")
                  ])
    ) var currentAdhocLogs: FetchedResults<Log>
    
    @FetchRequest(entity: Log.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "isRoutine == true AND isToDo == true")
    ) var allRoutineLogs: FetchedResults<Log>
    
    var logsTodayDone: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart) ?? Date()
        return filter(currentAdhocLogs).filter { log in
            (log.wrappedActivityDate >= todayStart) &&
                (log.wrappedActivityDate < tomorrowStart) &&
                (log.isToDo == false)
        }
    }
    var logsYesterdayDone: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let yesterdayStart = Calendar.current.date(byAdding: .day, value: -1, to: todayStart) ?? Date()
        return filter(currentAdhocLogs).filter { log in
            (log.wrappedActivityDate >= yesterdayStart) &&
                (log.wrappedActivityDate < todayStart) &&
                (log.isToDo == false)
        }
    }
    var adhocLogsTodayToDo: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart) ?? Date()
        return filter(currentAdhocLogs).filter { log in
            (log.wrappedActivityDate >= todayStart) &&
                (log.wrappedActivityDate < tomorrowStart) &&
                (log.isToDo == true)
        }
    }
    var adhocLogsYesterdayToDo: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let yesterdayStart = Calendar.current.date(byAdding: .day, value: -1, to: todayStart) ?? Date()
        return filter(currentAdhocLogs).filter { log in
            (log.wrappedActivityDate >= yesterdayStart) &&
                (log.wrappedActivityDate < todayStart) &&
                (log.isToDo == true)
        }
    }
    var routineLogsToday: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let tomorrowStart = Calendar.current.date(byAdding: .day, value: 1, to: todayStart) ?? Date()
        return filter(allRoutineLogs).filter { log in
            (log.wrappedActivityDate < tomorrowStart) &&
                (logsTodayDone.firstIndex(where: { $0.routineLogId == log.id }) == nil) &&
                (isFiltered == false ||
                    isFiltered == true && log.wrappedCategory == filterCategory.category.name
            )
        }
    }
    var routineLogsYesterday: [Log] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        return filter(allRoutineLogs).filter { log in
            (log.wrappedActivityDate < todayStart) &&
                (logsYesterdayDone.firstIndex(where: { $0.routineLogId == log.id }) == nil) &&
                (isFiltered == false ||
                    isFiltered == true && log.wrappedCategory == filterCategory.category.name
            )
        }
    }
    var logsTodayToDo: [Log] {
        adhocLogsTodayToDo + routineLogsToday
    }
    var logsYesterdayToDo: [Log] {
        adhocLogsYesterdayToDo + routineLogsYesterday
    }

    /* Weekly and Monthly Part*/
    @FetchRequest(entity: Log.entity(),
                  sortDescriptors: [],
                  predicate: NSCompoundPredicate(type: .and, subpredicates: [
                      NSPredicate(format: "activityDate >= %@", Date().addingTimeInterval(-60*60*24*60) as CVarArg),
                      NSPredicate(format: "isToDo == false")
                  ])
    ) var historicalLogs: FetchedResults<Log>
    
    var logsByWeek: Dictionary<String, [Log]> {
        Dictionary(grouping: filter(historicalLogs)) { (log) -> String in
            let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: log.date)
            return String(components.yearForWeekOfYear ?? 0) + "-" + String(format: "%02d", components.weekOfYear ?? 0)
        }
    }
    var logsByMonth: Dictionary<String, [Log]> {
        Dictionary(grouping: filter(historicalLogs)) { (log) -> String in
            let components = Calendar.current.dateComponents([.year, .month], from: log.date)
            return String(components.year ?? 0) + "-" + String(format: "%02d", components.month ?? 0)
        }
    }
    var thisWeek: String {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return String(components.yearForWeekOfYear ?? 0) + "-" + String(format: "%02d", components.weekOfYear ?? 0)
    }
    var prevWeek: String {
        var dateComponent = DateComponents()
        dateComponent.weekOfYear = -1
        let prevDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: prevDate!)
        return String(components.yearForWeekOfYear ?? 0) + "-" + String(format: "%02d", components.weekOfYear ?? 0)
    }
    var thisMonth: String {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        return String(components.year ?? 0) + "-" + String(format: "%02d", components.month ?? 0)
    }
    var prevMonth: String {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        let prevDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let components = Calendar.current.dateComponents([.year, .month], from: prevDate!)
        return String(components.year ?? 0) + "-" + String(format: "%02d", components.month ?? 0)
    }
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
    }
//    var todayToDo: String {
//        return dateFormatter.string(from: Date()) + "-ToDo"
//    }
//    var todayDone: String {
//        return dateFormatter.string(from: Date()) + "-Done"
//    }
//    var yesterdayToDo: String {
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        return dateFormatter.string(from: yesterday!) + "-ToDo"
//    }
//    var yesterdayDone: String {
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//        return dateFormatter.string(from: yesterday!) + "-Done"
//    }
//    var logsForCurrent: Dictionary<String, [Log]> {
//        Dictionary(grouping: filteredCurLogs) { (log) -> String in
//            let activityDate = dateFormatter.string(from: log.wrappedActivityDate)
//            let toDoString = log.isToDo ? "ToDo" : "Done"
//            return activityDate + "-" + toDoString
//        }
//    }
    var chartMessageA: [LocalizedStringKey] {
        var messages: [LocalizedStringKey] = []
        for i in 0...9 {
            messages.append(LocalizedStringKey("chartMessageA" + String(i)))
        }
        return messages
    }
    var chartMessageB: [LocalizedStringKey] {
        var messages: [LocalizedStringKey] = []
        for i in 0...9 {
            messages.append(LocalizedStringKey("chartMessageB" + String(i)))
        }
        return messages
    }
    var chartMessageC: [LocalizedStringKey] {
        var messages: [LocalizedStringKey] = []
        for i in 0...9 {
            messages.append(LocalizedStringKey("chartMessageC" + String(i)))
        }
        return messages
    }

    func getMessage(_ todayDone: Int, _ todaytoDo: Int, _ yesterdayDone: Int, _ yesterdayToDo: Int) -> LocalizedStringKey {
        var dailyTarget = modelData.userProfile.dailyTarget
        if dailyTarget == 0 {
            dailyTarget = 5
        }
        let selectedIndex = min(Int((todayDone/dailyTarget)*5), 9)
        if yesterdayDone < dailyTarget/2 {
            return chartMessageA[selectedIndex]
        } else if yesterdayDone < dailyTarget {
            return chartMessageB[selectedIndex]
        } else {
            return chartMessageC[selectedIndex]
        }
    }
            
    var body: some View {
//        let logsTodayToDo = logsForCurrent[todayToDo] ?? []
//        let logsTodayDone = logsForCurrent[todayDone] ?? []
//        let logsYesterdayToDo = logsForCurrent[yesterdayToDo] ?? []
//        let logsYesterdayDone = logsForCurrent[yesterdayDone] ?? []
        
        NavigationView {
            ScrollView {
                VStack {
                    if isFiltered {
                        Text("Applied Fileter: \(filterCategory.category.icon ?? "")\(filterCategory.category.name)")
                            .padding(.top, 20)
                            .padding(.bottom, 0)
                    }
                    HStack {
                        Text(modelData.userProfile.usericon)
                            .font(.system(size: 100))
                            .padding([.leading, .top], 20)
                        ChatBubble(direction: .left) {
                            Text(getMessage(logsTodayDone.count, logsTodayToDo.count, logsYesterdayDone.count, logsYesterdayToDo.count))
                                .padding(.all, 15)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                        }
                    }
                    HStack {
                        VStack {
                            Text("Today")
                                .font(.title3)
                            HStack {
                                CircleCount(title: "Done", count: logsTodayDone.count, width: 80,  color: .accentColor)
                                CircleCount(title: "To Do", count: logsTodayToDo.count, width: 80,  color: .gray)
                            }
                        }
                        VStack {
                            Text("Yesterday")
                                .font(.title3)
                            HStack {
                                CircleCount(title: "Done", count: logsYesterdayDone.count, width: 80,  color: .green)
                                CircleCount(title: "To Do", count: logsYesterdayToDo.count, width: 80,  color: .gray)
                            }
                        }
                    }
                    Divider()
                        .padding(.top, 20)
                    Text("Weekly Achievement")
                        .font(.title)

                    HStack {
                        CircleCount(title: "This week", count: logsByWeek[thisWeek]?.count ?? 0, width: 140, color: .accentColor)
                            .padding(20)
                        CircleCount(title: "Last week", count: logsByWeek[prevWeek]?.count ?? 0, width: 140, color: .green)
                            .padding(20)
                    }

                    Divider()
                    
                    Text("Monthly Achievement")
                        .font(.title)

                    HStack {
                        CircleCount(title: "This month", count: logsByMonth[thisMonth]?.count ?? 0, width: 140,  color: .accentColor)
                            .padding(20)
                        CircleCount(title: "Last month", count: logsByMonth[prevMonth]?.count ?? 0, width: 140, color: .green)
                            .padding(20)
                    }
                    if logsByMonth[thisMonth] != nil {
                        if groupByCategory(logsByMonth[thisMonth]!)["Book"] != nil {
                            Text("Book: \(groupByCategory(logsByMonth[thisMonth]!)["Book"]!.count)")
                        }
                    }

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Chart View")
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
                    
                    case .profile:
                        ProfileHost()
                            .environmentObject(modelData)
                    }
                }

            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func groupByCategory(_ logs : [Log])-> Dictionary<String, [Log]> {
        return  Dictionary(grouping: logs) { (log) -> String in
            log.category ?? ""
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(ModelData())
    }
}
