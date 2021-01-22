//
//  MaterialDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 21/01/2021.
//

import SwiftUI

struct MaterialDetail: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    var material: Material
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        self.material.image.map({
                            UIImage(data: $0)
                                .map({
                                        Image(uiImage: $0)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height:150)
                                            .clipped()
                                            .listRowInsets(EdgeInsets())
                                })
                        })
                        Text(self.material.wrappedGenre.uppercased())
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    Text(self.material.wrappedName)
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Text(self.material.wrappedDesc)
                        .foregroundColor(.secondary)
                    
                    List {
                        ForEach(material.logArray, id: \.self) { log in
                            MaterialLogRow(log: log)
                        }
                    }
                }
            }
        }
    }
}

struct MaterialDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let material1 = Material(context: context)
        material1.name = "Test book"
        material1.category = "Book"
        material1.updateDate = Date()
        return MaterialDetail(material: material1)
    }
}
