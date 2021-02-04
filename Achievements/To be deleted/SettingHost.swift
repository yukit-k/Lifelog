////
////  ProfileHost.swift
////  Landmarks
////
////  Created by Yuki Takahashi on 03/01/2021.
////
//
//import SwiftUI
//
//struct SettingHost: View {
//    @Environment(\.editMode) var editMode
//    @EnvironmentObject var modelData: ModelData
//    @StateObject var draftSettings = UserSettings()
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            HStack {
//                if editMode?.wrappedValue == .active {
//                    Button("Cancel") {
//                        self.setDraft()
//                        editMode?.animation().wrappedValue = .inactive
//                    }
//                    .padding(.top, 25)
//                    .padding(.leading, 30)
//                }
//                Spacer()
//                EditButton()
//                    .padding(.top, 25)
//                    .padding(.trailing, 30)
//            }
//            if editMode?.wrappedValue == .inactive {
//                SettingSummary(userSettings: draftSettings)
//            } else {
//                SettingEditor(userSettings: draftSettings)
//                    .onAppear {
//                        self.setDraft()
//                    }
//                    .onDisappear {
//                        draftSettings.save()
//                        modelData.userSettings = draftSettings
//                        
//                    }
//            }
//        }
//        //.padding()
//    }
//    func setDraft() {
//        draftSettings.username = modelData.userSettings.username
//        draftSettings.notification = modelData.userSettings.notification
//        draftSettings.categories = modelData.userSettings.categories
//    }
//}
//
//struct SettingHost_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingHost()
//            .environmentObject(ModelData())
//    }
//}
