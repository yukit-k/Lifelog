//
//  ContentView.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewRouter: ViewRouter
    @State var showPopup: Bool = false
    
    var body: some View {
        // LandmarkList()
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentTab {
                case .highlight:
                    Highlight()
                case .list:
                    AchievementList()
                case .chart:
                    Text("Chart View")
                case .calendar:
                    Text("Calendar View")
                }
                
                Spacer()
                ZStack {
                    if showPopup {
                        PlusMenu(widthAndHeight: geometry.size.width/6)
                            .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .highlight, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "star", tabName: "Highlight")
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .list, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "list.bullet", tabName: "List")
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
                                .foregroundColor(.accentColor)
                                .rotationEffect(Angle(degrees: showPopup ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/10/2.5)
                        .onTapGesture {
                            withAnimation {
                                showPopup.toggle()
                            }
                        }
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .chart, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "chart.bar", tabName: "Chart")
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .calendar, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "calendar", tabName: "Calendar")
                     }
                         .frame(width: geometry.size.width, height: geometry.size.height/10)
                    .background(Color(.secondarySystemBackground).shadow(radius: 2))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
            
/*
            TabView(selection: $selection) {
                CategoryHome()
                    .tabItem {
                        Label("Highlight", systemImage: "star")
                    }
                    .tag(Tab.featured)
                LandmarkList()
                    .tabItem {
                        Label("List", systemImage: "list.bullet")
                    }
                    .tag(Tab.list)

                Text("some actions")
                    .tabItem {
                    }

                Text("Show Chart")
                    .tabItem {
                        Label("Chart", systemImage: "chart.bar")
                    }
                    .tag(Tab.chart)

                Text("Calendar")
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(Tab.calendar)
            }
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                    .shadow(radius: 4)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
                    .foregroundColor(Color("DarkPurple"))
            }
            .offset(x: geometry.size.width / 2 - 20, y: geometry.size.height - 80)
            .onTapGesture {
                self.showActionSheet.toggle()
            }
            
            
        }
        .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("some actions"))
                }
 */
        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .environmentObject(ModelData())
    }
}
