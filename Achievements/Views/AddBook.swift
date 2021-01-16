//
//  AddBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/01/2021.
//

import SwiftUI
import Combine

struct AddBook: View {
    let genre = ["Fiction","Fairy Tales", "Sci-Fi", "History", "Biography", "Poetry", "Non-Fiction", "Textbook", "Others"]
    
    @State var selectedGenreIndex = 8
    @State var title = ""
    @State var description = ""
    @State var recordDate = Date()
    @State var comment = ""
    @State var pageCount = ""
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
                    TextField("Short Description", text: $description)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Number of pages", text: $pageCount)
                        .keyboardType(.numberPad)
                        .onReceive(Just(pageCount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.pageCount = filtered
                            }
                            self.toPage = Int(self.pageCount) ?? 1
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
                
                Button(action: {
                    print("Book added!")
                }) {
                    Text("Add Book")
                }
            }
            .navigationTitle("Add Book")
        }
        
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
    }
}
