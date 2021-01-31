//
//  ModelData.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var photoIndex = Int.random(in: 0...13)
    @Published var topImages = ["mountains-190056", "mountains-2031539", "adventure-1807524", "ama-dablam-2064522", "lake-1581879", "mountain-547363", "nepal-2184940", "schilthorn-3033448", "alberta-2297204", "fog-4436636", "lake-1681485", "mountains-736886", "person-1245959", "sunset-1757593"]
    @Published var userSettings = UserSettings()
}
