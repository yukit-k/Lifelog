//
//  FileIOController.swift
//  Achievements
//
//  Created by Yuki Takahashi on 30/01/2021.
//

import SwiftUI

class FileIOController {
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
