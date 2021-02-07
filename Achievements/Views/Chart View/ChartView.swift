//
//  ChartView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 23/01/2021.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { item in
            self.content(item)
        }
    }

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}

struct ChartView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var modelData: ModelData
    @State private var activeSheet: ActiveSheetNavBar?
    
    @State private var isFiltered: Bool = false
    @StateObject var filterCategory = CategoryItem()
    
    var fetchRequestHistory = FetchRequest<Log>(entity: Log.entity(),
                        sortDescriptors: [],
                        predicate: NSCompoundPredicate(type: .and, subpredicates: [
                            NSPredicate(format: "activityDate >= %@", Date().addingTimeInterval(-60*60*24*60) as CVarArg),
                            NSPredicate(format: "isToDo == false")
                        ])
    )
    var logs: FetchedResults<Log> { fetchRequestHistory.wrappedValue }
    var filteredLogs: [Log] {
        logs.filter { log in
            (isFiltered == false ||
                isFiltered == true && log.wrappedCategory == filterCategory.category.name
            )
        }
    }
    
    var fetchRequestCurrent = FetchRequest<Log>(entity: Log.entity(),
                        sortDescriptors: [],
                        predicate: NSPredicate(format: "activityDate >= %@", Date().addingTimeInterval(-60*60*24*2) as CVarArg)
    )
    var curLogs: FetchedResults<Log> { fetchRequestCurrent.wrappedValue }
    var filteredCurLogs: [Log] {
        curLogs.filter { log in
            (isFiltered == false ||
                isFiltered == true && log.wrappedCategory == filterCategory.category.name
            )
        }
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
    var logsByMonth: Dictionary<String, [Log]> {
        Dictionary(grouping: filteredLogs) { (log) -> String in
            let components = Calendar.current.dateComponents([.year, .month], from: log.date)
            return String(components.year ?? 0) + "-" + String(format: "%02d", components.month ?? 0)
        }
//        .map { (key: String, value: [Log]) -> (month: String, logs: [Log]) in
//                (month: key, logs: value)
//        }
//        .sorted { (left, right) -> Bool in
//            left.month < right.month
//        }
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
    var logsByWeek: Dictionary<String, [Log]> {
        Dictionary(grouping: filteredLogs) { (log) -> String in
            let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: log.date)
            return String(components.yearForWeekOfYear ?? 0) + "-" + String(format: "%02d", components.weekOfYear ?? 0)
        }
    }
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }
    var todayToDo: String {
        return dateFormatter.string(from: Date()) + "-ToDo"
    }
    var todayDone: String {
        return dateFormatter.string(from: Date()) + "-Done"
    }
    var yesterdayToDo: String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return dateFormatter.string(from: yesterday!) + "-ToDo"
    }
    var yesterdayDone: String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return dateFormatter.string(from: yesterday!) + "-Done"
    }
    var logsForCurrent: Dictionary<String, [Log]> {
        Dictionary(grouping: filteredCurLogs) { (log) -> String in
            let activityDate = dateFormatter.string(from: log.wrappedActivityDate)
            let toDoString = log.isToDo ? "ToDo" : "Done"
            return activityDate + "-" + toDoString
        }
    }

    func getMessage(_ todayDone: Int, _ todaytoDo: Int, _ yesterdayDone: Int, _ yesterdayToDo: Int) -> LocalizedStringKey {
        if todayDone == 0 {
            if yesterdayDone == 0 {
                return "chartMessage1"
            } else if yesterdayDone < 2 {
                return "chartMessage2"
            } else {
                return "chartMessage3"
            }
        } else if todayDone < 2 {
            if yesterdayDone < 2 {
                return "chartMessage4"
            } else {
                return "chartMessage5"
            }
        } else {
            return "chartMessage6"
        }
    }
            
    var body: some View {
        let logsTodayToDo = logsForCurrent[todayToDo]
        let logsTodayDone = logsForCurrent[todayDone]
        let logsYesterdayToDo = logsForCurrent[yesterdayToDo]
        let logsYesterdayDone = logsForCurrent[yesterdayDone]
        
        
        
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
                            Text(getMessage(logsTodayDone?.count ?? 0, logsTodayToDo?.count ?? 0, logsYesterdayDone?.count ?? 0, logsYesterdayToDo?.count ?? 0))
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
                                CircleCount(title: "Done", count: logsTodayDone?.count ?? 0, width: 80,  color: .accentColor)
                                CircleCount(title: "To Do", count: logsTodayToDo?.count ?? 0, width: 80,  color: .gray)
                            }
                        }
                        VStack {
                            Text("Yesterday")
                                .font(.title3)
                            HStack {
                                CircleCount(title: "Done", count: logsYesterdayDone?.count ?? 0, width: 80,  color: .green)
                                CircleCount(title: "To Do", count: logsYesterdayToDo?.count ?? 0, width: 80,  color: logsYesterdayToDo?.count ?? 0 > 0 ? .red : .gray)
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
