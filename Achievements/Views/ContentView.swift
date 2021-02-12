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
                case .list:
                    ListView()
                case .chart:
                    ChartView()
                case .today:
                    TodayView()
                }
   
                ZStack(alignment: .bottom) {
                    if viewRouter.showPopup {
                        HStack(alignment: .bottom) {
                            PlusMenu(viewRouter: viewRouter, widthAndHeight: geometry.size.width/6)
                                .offset(x: 0, y: -geometry.size.height/3)
                        }
                        .frame(width: geometry.size.width, height: 10)
                        .transition(.scale)
//                        .offset(x: 0, y: -500)
                    }
                    HStack() {
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .highlight, width: geometry.size.width/5, height: geometry.size.height/40, systemIconName: "star", tabName: "Picture")
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .today, width: geometry.size.width/5, height: geometry.size.height/40, systemIconName: "checkmark.square", tabName: "Today")
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.height/12, height: geometry.size.height/12)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: geometry.size.height/12-6, height: geometry.size.height/12-6)
                                .foregroundColor(.accentColor)
                                .rotationEffect(Angle(degrees: viewRouter.showPopup ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/24)
                        .onTapGesture {
                            withAnimation {
                                viewRouter.showPopup.toggle()
                            }
                        }
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .list, width: geometry.size.width/5, height: geometry.size.height/40, systemIconName: "list.bullet", tabName: "List")
                        TabBarIcon(viewRouter: viewRouter, assignedTab: .chart, width: geometry.size.width/5, height: geometry.size.height/40, systemIconName: "chart.bar", tabName: "Chart")
                     }
                    .frame(width: geometry.size.width, height: geometry.size.height/12)
//                        .position(y:geometry.size.height - 50)
                    .background(Color(.secondarySystemBackground).shadow(radius: 2))
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $viewRouter.showAddSheet) {
            AddNewLog(category: viewRouter.category)
                .environmentObject(modelData)
        
        }
    }
}        
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
            .environmentObject(ModelData())
            .environment(\.locale, .init(identifier: "ja"))
    }
}
