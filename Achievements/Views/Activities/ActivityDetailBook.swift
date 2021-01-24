//
//  BookDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//

import SwiftUI
import CoreData

struct ActivityDetailBook: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let log: Log
    
    let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        self.log.wrappedMaterial.image.map({
                            UIImage(data: $0)
                                .map({
                                        Image(uiImage: $0)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:300, height:300)
                                            .clipped()
                                })
                        })
                        Text(self.log.wrappedMaterial.wrappedGenre.uppercased())
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    Text(self.log.wrappedMaterial.wrappedName)
                        .font(.title)
                        .foregroundColor(.primary)
                    HStack{
                        Text("\(self.log.wrappedMaterial.totalAmount, specifier: "%.0f") pages:")
                        Text(self.log.wrappedMaterial.wrappedDesc)
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
                    HStack {
                        Text("Date")
                            .font(.headline)
                        Text("\(log.wrappedRecordDate, formatter: self.logDateFormat)")
                        if self.log.isToDo {
                            Text(" To Do ")
                                .font(.caption)
                                .fontWeight(.black)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(Color.orange.opacity(0.85))
                                .clipShape(Capsule())
                        } else {
                            Text(" Done ")
                                .font(.caption)
                                .fontWeight(.black)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(Color.green.opacity(0.85))
                                .clipShape(Capsule())

                        }
                        Spacer()
                    }
                        .padding(.horizontal)

                    HStack {
                        Text("Pages")
                            .font(.headline)
                        Text("\(self.log.taskAmount, specifier: "%.0f")")
                            .font(.title2)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.accentColor)
                        Text(" pages")
                        Text("(from \(self.log.fromPosition) to \(self.log.toPosition))")
                        Spacer()
                    }
                        .padding()

                    RatingView(rating: .constant(Int(self.log.rating)))
                        .font(.headline)
                        .padding(.horizontal)
                    HStack {
                        Text("Comment")
                            .font(.headline)
                        Text(self.log.wrappedComment)
                        Spacer()
                    }
                        .padding()
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text(log.material?.wrappedName ?? "Unknown Book"), displayMode: .inline)
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
        moc.delete(log)
        
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct ActivityDetailBook_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.material?.name = "Test book"
        log1.material?.category = "Book"
        log1.material?.updateDate = Date()
        log1.material?.genre = "Fantasy"
        log1.material?.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.recordDate = Date()
        return ActivityDetailBook(log: log1).environment(\.managedObjectContext, context)
        
    }
}
