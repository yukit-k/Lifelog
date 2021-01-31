//
//  ImagePicker.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    class Coordicator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
//        @Binding var image: Image?
//        @Binding var isPresented: Bool
        
    //    init(image: Binding<Image?>, isPresented: Binding<Bool>) {
    //        self._image = image
    //        self._isPresented = isPresented
    //    }
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage.size.width > 600 ? uiImage.resized(toWidth: 600.0) : uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
            //parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
            //parent.isPresented = false
        }

    }
    
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    //@Binding var isPresented: Bool
    
    func makeCoordinator() -> Coordicator {
        //return BookImagePickerCoordicator(image: $image, isPresented: $isPresented)
        Coordicator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // something
    }
}


