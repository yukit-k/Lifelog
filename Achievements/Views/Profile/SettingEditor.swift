//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 04/01/2021.
//

import SwiftUI

struct SettingEditor: View {
    @ObservedObject var userSettings = UserSettings()
        
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Form {
                Section(header: Text("Profile")) {
                    TextField("Username", text: $userSettings.username)
                    Toggle(isOn: $userSettings.notification) {
                        Text("Notify To-Do")
                    }
                }
                Section(header: Text("Category")) {
                    
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingEditor_Previews: PreviewProvider {
    static var previews: some View {
        SettingEditor()
    }
}
