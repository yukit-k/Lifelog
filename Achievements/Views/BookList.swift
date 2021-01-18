//
//  BookDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 16/01/2021.
//

import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.recordDate, ascending: false),
        NSSortDescriptor(keyPath: \Book.title, ascending: true)
    ]) var books: FetchedResults<Book>
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: BookDetail(book: book)) {
                        EmojiRating(rating: book.rating)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Ttile")
                                .font(.headline)
                            
                            Text(book.shortDesc ?? "No Description")
                                .font(.subheadline)
                            //Text(book.recordDate)
                            //    .font(.subheadline)
                        }
                            //let progress = Int((book.toPage - book.fromPage) / book.totalPage * 100)
                            //Text("\(progress) %")
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Book List")
            .navigationBarItems(leading: EditButton(), trailing:
                                Button(action: {
                                    self.showingAddScreen.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
            )
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBook().environment(\.managedObjectContext, self.moc)

        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
    
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
    }
}
