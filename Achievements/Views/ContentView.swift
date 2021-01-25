//
//  ContentView.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                switch viewRouter.currentTab {
                case .highlight:
                    MaterialView()
                case .list:
                    ActivityList()
                case .chart:
                    ChartView()
                case .calendar:
                    Text("Calendar View")
                }
                
                Spacer()
                ZStack {
                    if viewRouter.showPopup {
                        PlusMenu(viewRouter: viewRouter, widthAndHeight: geometry.size.width/6)
                            .offset(y: -geometry.size.height/6)
                            
                    }
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .highlight, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "star", tabName: "Achievement")
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .list, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "list.bullet", tabName: "Activity")
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
                                .foregroundColor(.accentColor)
                                .rotationEffect(Angle(degrees: viewRouter.showPopup ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/10/2.5)
                        .onTapGesture {
                            withAnimation {
                                viewRouter.showPopup.toggle()
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
            .sheet(isPresented: $viewRouter.showAddSheet) {
                switch viewRouter.activeSheet {
                case .first:
                    AddNewItem()
                case .second:
                    AddLog()
                }
            }
        }
    }
}        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .environmentObject(StartupData())
    }
}
