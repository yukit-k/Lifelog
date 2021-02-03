//
//  ProfileSummary.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

enum ActiveSheetProfileView: Identifiable {
    case profile, background
    
    var id: Int {
        hashValue
    }
}

struct ProfileSummary: View {
    @EnvironmentObject var modelData: ModelData
    let fileController = FileIOController()
    
    @State private var image: Image?
    @State private var backImage: Image?
    
    init () {
        _image = State(initialValue: fileController.loadImage(name: "profile.png") ?? Image("snowman_nana"))
        _backImage = State(initialValue: fileController.loadImage(name: "background.png") ?? Image("sunset-1757593"))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                VStack {
                    backImage?
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        
                    HStack {
                        Spacer()
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .offset(x: 0, y: -100)
                            .padding(.bottom, -100)
                        Spacer()
                    }
                }
                
                
                HStack {
                    Spacer()
                    Text(modelData.userSettings.username)
                        .bold()
                        .font(.title)
                        .padding(.top, 10)
                        .padding(.bottom, 4)
                    Spacer()
                }
                HStack {
                    Text("Notification: ")
                    Text(modelData.userSettings.notification ? "On (coming soon)" : "Off (coming soon)")
                        .foregroundColor(.secondary)
                }
                EditButton()
                    .padding()
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Completed Badges")
                        .font(.headline)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            Text("Coming Soon!")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)

    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
    }
}
