//
//  BookDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//

import SwiftUI
import CoreData

struct BookDetail: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        self.book.image.map({
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
                        Text(self.book.genre?.uppercased() ?? "FANTASY")
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: -5)
                    }
                    Text(self.book.title ?? "No Title")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Text(self.book.shortDesc ?? "No short description")
                        .foregroundColor(.secondary)
                    
                    Text(self.book.comment ?? "No Comment")
                    
                    RatingView(rating: .constant(Int(self.book.rating)))
                        .font(.headline)
                        .padding()

                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
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
        moc.delete(book)
        
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct BookDetail_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let bookTest = Book(context: context)
        bookTest.title = "Test book"
        bookTest.shortDesc = "Some interesting book."
        bookTest.genre = "Fantasy"
        bookTest.rating = 4
        bookTest.comment = "This was a great book"
        bookTest.recordDate = Date()
        return BookDetail(book: bookTest).environment(\.managedObjectContext, context)
        
    }
}
