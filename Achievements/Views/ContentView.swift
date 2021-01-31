//
//  ContentView.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                switch viewRouter.currentTab {
                case .highlight:
                    PictureView()
//                        .frame(width: geometry.size.width, height: geometry.size.height - 50)
                case .list:
                    ListView()
                case .chart:
                    ChartView()
                case .calendar:
                    CalendarView()
                }
   
                ZStack(alignment: .bottom) {
                    if viewRouter.showPopup {
                        PlusMenu(viewRouter: viewRouter, widthAndHeight: 70)
                            .offset(y: -150)
                    }
                    HStack() {
                            TabBarIcon(viewRouter: viewRouter, assignedTab: .highlight, width: geometry.size.width/5, height: 15, systemIconName: "star", tabName: "Achievement")
                            TabBarIcon(viewRouter: viewRouter, assignedTab: .list, width: geometry.size.width/5, height: 15, systemIconName: "list.bullet", tabName: "Activity")
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .shadow(radius: 4)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 50-6, height: 50-6)
                                    .foregroundColor(.accentColor)
                                    .rotationEffect(Angle(degrees: viewRouter.showPopup ? 90 : 0))
                            }
                                .offset(y: -25)
                            .onTapGesture {
                                withAnimation {
                                    viewRouter.showPopup.toggle()
                                }
                            }
                            TabBarIcon(viewRouter: viewRouter, assignedTab: .chart, width: geometry.size.width/5, height: 15, systemIconName: "chart.bar", tabName: "Chart")
                            TabBarIcon(viewRouter: viewRouter, assignedTab: .calendar, width: geometry.size.width/5, height: 15, systemIconName: "calendar", tabName: "Calendar")
                         }
                        .frame(width: geometry.size.width, height: 50)
//                        .position(y:geometry.size.height - 50)
                        .background(Color(.secondarySystemBackground).shadow(radius: 2))
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            .sheet(isPresented: $viewRouter.showAddSheet) {
                AddNewLog(category: viewRouter.category)
            
        }
    }
}        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .environmentObject(ModelData())
    }
}
