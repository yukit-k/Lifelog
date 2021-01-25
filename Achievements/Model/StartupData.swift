//
//  ModelData.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import Foundation
import Combine

final class StartupData: ObservableObject {
    @Published var profile = Profile.default
    @Published var photoIndex = Int.random(in: 0...1)
}
