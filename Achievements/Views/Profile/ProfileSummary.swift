//
//  ProfileSummary.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct FileIOController {
    func write(_ value: Data, toDocumentNamed documentName: String) throws {
        let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let fileURL = folderURL.appendingPathComponent(documentName)
        print(fileURL)
        try value.write(to: fileURL)
    }
    func loadImage(name: String, type: String = "png") -> Image? {
        let folderURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        let fileURL = folderURL.appendingPathComponent(name)
        print(fileURL)
        do {
            let data = try Data(contentsOf: fileURL)
            guard let uiImage = UIImage(data: data) else { return nil }
            return Image(uiImage: uiImage)
        } catch {
            return nil
        }
    }
}

enum ActiveSheetProfileView: Identifiable {
    case profile, background
    
    var id: Int {
        hashValue
    }
}

struct ProfileSummary: View {
    @EnvironmentObject var startupData: StartupData
    let fileController = FileIOController()
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingImageActionSheet = false
    @State private var useCamera = false
    
    @State private var backImage: Image?
    @State private var inputBackImage: UIImage?
    @State private var activeSheet: ActiveSheetProfileView?
    
    @State private var userName = UserDefaults.standard.string(forKey: "username")
    
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
                        .frame(height: 150)
                        .edgesIgnoringSafeArea(.top)
                        .onTapGesture {
                            activeSheet = .background
                            showingImagePicker = true
                        }
                    
                    HStack {
                        Spacer()
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                            .offset(x: 0, y: -50)
                            .padding(.bottom, -50)
                            .onTapGesture {
                                showingImageActionSheet = true
                            }
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    Text(userName ?? "Nana")
                        .bold()
                        .font(.title)
                        .padding()
                    Spacer()
                }
                
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
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                switch activeSheet! {
                case .profile:
                    ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$inputImage, isPresented: self.$showingImagePicker)
                case .background:
                    ImagePicker(sourceType: .photoLibrary, image: self.$inputBackImage, isPresented: self.$showingImagePicker)
                }
            }
            .actionSheet(isPresented: $showingImageActionSheet) { () -> ActionSheet in
                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                    useCamera = true
                    activeSheet = .profile
                    showingImagePicker.toggle()
                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                    self.useCamera = false
                    activeSheet = .profile
                    showingImagePicker.toggle()
                }), ActionSheet.Button.cancel()])
            }

        }
    }
    
    
    func loadImage() {
        switch activeSheet {
        case .profile:
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
        
            if useCamera {
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: inputImage)
            }
            do {
                try self.fileController.write(inputImage.pngData()!, toDocumentNamed: "profile.png")
            } catch {
                print(error)
            }
        default:
            guard let inputBackImage = inputBackImage else { return }
            backImage = Image(uiImage: inputBackImage)
            do {
                try self.fileController.write(inputBackImage.pngData()!, toDocumentNamed: "background.png")
            } catch {
                print(error)
            }
        }
        
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
    }
}
