//
//  ProfileHost.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct SettingHost: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel") {
                        //draftProfile = startupData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            if editMode?.wrappedValue == .inactive {
                SettingSummary()
            } else {
                SettingEditor()
                    .onAppear {
                        //draftProfile = draftProfile
                    }
                    .onDisappear {
                        //startupData.profile = draftProfile
                    }
            }
        }
        .padding()
    }
}

struct SettingHost_Previews: PreviewProvider {
    static var previews: some View {
        SettingHost()
    }
}
