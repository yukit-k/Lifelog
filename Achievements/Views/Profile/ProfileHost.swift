//
//  ProfileHost.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
//    @StateObject var draftSettings = UserSettings()
    var body: some View {
        if editMode?.wrappedValue == .inactive {
            ProfileSummary()
        } else {
            ProfileEditor()
        }
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
    }
}
