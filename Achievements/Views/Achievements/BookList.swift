//
//  BookDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 16/01/2021.
//

import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [])
    var books: FetchedResults<Book>
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id: \.id) { book in
                    HStack {
                        VStack {
                            Text(book.title ?? "Unknown")
                                .font(.headline)
                            //Text(book.recordDate)
                            //    .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {print("Update Book")}) {
                            //let progress = Int((book.toPage - book.fromPage) / book.totalPage * 100)
                            //Text("\(progress) %")
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        moc.delete(books[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .navigationBarTitle("Book List")
            .navigationBarItems(trailing:
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
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
    }
}
