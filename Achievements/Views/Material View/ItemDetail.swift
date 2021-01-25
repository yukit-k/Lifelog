//
//  MaterialDetailBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 23/01/2021.
//

import SwiftUI
import CoreData

struct ItemDetail: View {
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
            VStack(spacing: 20) {
                ZStack(alignment: .bottomTrailing) {
                    material.image.map({
                        UIImage(data: $0)
                            .map({
                                    Image(uiImage: $0)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:300, height:200)
                                        .clipped()
                            })
                    })
                    Text(material.wrappedGenre.uppercased())
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(material.wrappedName)
                    .font(.title)
                    .foregroundColor(.primary)
                HStack{
                    Text("\(material.totalVolume, specifier: "%.0f") \(material.wrappedTaskUnit)")
                    if material.wrappedDesc != "" {
                        Text(":")
                        Text(material.wrappedDesc)
                    }
                    Spacer()
                }
                HStack {
                    Text("Activity Log")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                List {
                    ForEach(material.logArray, id: \.self) { log in
                        ItemDetailLogRow(log: log, nextView: ActivityDetail(log: log))
                    }
                        .onDelete(perform: deleteLogs)
                }
//                    .frame(minHeight: 300)
            }
            .padding(.leading, 15)
        }
        .navigationBarTitle(Text(material.getCategoryIcon(material.wrappedCategory) + material.wrappedCategory), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete a material"), message: Text("All acticvity logs for this material will be deleted. Are you sure?"), primaryButton: .destructive(Text("Delete")){
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
    
    func deleteLogs(at offsets: IndexSet) {
        for offset in offsets {
            let log = material.logArray[offset]
            print("Deleting a log...")
            moc.delete(log)
        }
        
        if self.moc.hasChanges {
            do {
                try self.moc.save()
                print("Delete Log Completed.")
            } catch {
                print(error)
            }
        }
    }
}

//struct MaterialDetailBook_Previews: PreviewProvider {
//    static var previews: some View {
//        MaterialDetailBook()
//    }
//}
