//
//  AddBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/01/2021.
//

import SwiftUI
import Combine

struct AddBook: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    let genre = ["Fiction","Fairy Tales", "Sci-Fi", "History", "Biography", "Poetry", "Non-Fiction", "Textbook", "Others"]
    @State var selectedGenreIndex = 8
    @State var title = ""
    @State var shortDescription = ""
    @State var recordDate = Date()
    @State var comment = ""
    @State var totalPage = ""
    @State var fromPage = 1
    @State var toPage = 1
    @State var rating: Int = 3
    @State var image: Image? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("About the book")) {
                    TextField("Title", text: $title)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Short Description", text: $shortDescription)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Number of pages", text: $totalPage)
                        .keyboardType(.numberPad)
                        .onReceive(Just(totalPage)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.totalPage = filtered
                            }
                            self.toPage = Int(self.totalPage) ?? 1
                        }
                    Picker(selection: $selectedGenreIndex, label: Text("Genre")) {
                        ForEach(0 ..< genre.count) {
                            Text(self.genre[$0]).tag($0)
                        }
                    }
                    
                }
                
                Section(header: Text("Reading Record")) {
                    DatePicker("Record Date", selection: $recordDate, displayedComponents: .date)
                    
                    Picker("Read From", selection: $fromPage) {
                        ForEach(0 ..< 1000) {
                            Text("Page \($0)")
                        }
                    }
                    Picker("Read To", selection: $toPage) {
                        ForEach(0 ..< 1000) {
                            Text("Page \($0)")
                        }
                    }
                    RatingView(rating: $rating)
                    TextField("Comment", text: $comment)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)

                }
                
                Button("Save") {
                    let newBook = Book(context: self.moc)
                    newBook.title = self.title
                    newBook.shortDesc = self.shortDescription
                    newBook.totalPage = self.totalPage
                    newBook.genre = self.genre[selectedGenreIndex]
                    newBook.recordDate = self.recordDate
                    newBook.fromPage = Int16(self.fromPage)
                    newBook.toPage = Int16(self.toPage)
                    newBook.comment = self.comment
                    newBook.rating = Int16(self.rating)
                    
                    
                    try? self.moc.save()
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
            .navigationTitle("Add Book")
        }
        
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return AddBook().environment(\.managedObjectContext, context)
        AddBook()
    }
}
