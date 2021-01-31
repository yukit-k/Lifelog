//
//  ProfileHost.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct SettingHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @State private var draftSettings = UserSettings()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        draftSettings = modelData.userSettings
                        editMode?.animation().wrappedValue = .inactive
                    }
                    .padding()
                }
                Spacer()
                EditButton()
                    .padding()
            }
            if editMode?.wrappedValue == .inactive {
                SettingSummary(userSettings: modelData.userSettings)
            } else {
                SettingEditor(userSettings: $draftSettings)
                    .onAppear {
                        draftSettings = modelData.userSettings
                    }
                    .onDisappear {
                        modelData.userSettings = draftSettings
                    }
            }
        }
        //.padding()
    }
}

struct SettingHost_Previews: PreviewProvider {
    static var previews: some View {
        SettingHost()
            .environmentObject(ModelData())
    }
}
