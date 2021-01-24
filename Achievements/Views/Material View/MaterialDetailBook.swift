//
//  MaterialDetailBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 23/01/2021.
//

import SwiftUI
import CoreData

struct MaterialDetailBook: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
//    var fetchRequest: FetchRequest<Log>
    let material: Material
    
    let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
//    init(filter: String, object: Material) {
//        print(filter)
//        fetchRequest = FetchRequest<Log>(entity: Log.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Log.recordDate, ascending: false)
//        ], predicate: NSPredicate(format: "materialId CONTAINS[c] %@", filter))
//        material = object
//    }

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
                                            .frame(width:300, height:300)
                                            .clipped()
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
                    HStack{
                        Text("\(self.material.totalAmount, specifier: "%.0f") pages:")
                        Text(self.material.wrappedDesc)
                    }
                        .padding(2)
                    HStack {
                        Text("Reading Record")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .padding()
                        Spacer()
                    }
                    List {
                        ForEach(material.logArray, id: \.self) { log in
                            MaterialLogRow(log: log)
                        }
                    }
                        .frame(minHeight: 300)
                }
            }
        }
        .navigationBarTitle(Text(material.wrappedName), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")){
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(material)
        presentationMode.wrappedValue.dismiss()
        
    }
}

//struct MaterialDetailBook_Previews: PreviewProvider {
//    static var previews: some View {
//        MaterialDetailBook()
//    }
//}
