//
//  EditLog.swift
//  Achievements
//
//  Created by Yuki Takahashi on 27/01/2021.
//

import SwiftUI
import Combine
import Foundation
import CoreData

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct EditLog: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var editableLog: EditableLogData
    @State private var dateFieldName: String = ""
    @State private var nameFieldName: String = "Name"
    @State private var activityVolumeS: String = ""
    @State private var totalVolumeS: String = ""
    @State private var ratingInt: Int = 3
    @State private var isCompleted: Bool
    
    @State private var showingImagePicker = false
    @State private var showingImageActionSheet = false
    @State private var useCamera = false
    @State private var inputImage: UIImage?
    
    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingOverrideAlert = false

    let bookGenre = ["Not Selected", "Picture Book", "Fiction", "Non-Fiction", "Textbook", "Others"]
    let taskGenre = ["Not Selected", "Study", "Choir", "Hobby", "Job", "Others"]
    let exerciseGenre = ["Not Selected", "Running", "Walking", "Cycling", "Indoor", "Outdoor", "Others"]
    let cookGenre = ["Not Selected", "Dinner", "Lunch", "Breakfast", "Desert", "Others"]
    let othersGenre = ["Not Selected", "Others"]

    init(log: Log) {
        _editableLog = State(initialValue: EditableLogData(from: log))
        if log.isToDo {
            _dateFieldName = State(initialValue: "Planned Date")
        } else {
            _dateFieldName = State(initialValue: "Record Date")
        }
        _activityVolumeS = log.activityVolume > 0 ? State(initialValue: String(log.activityVolume)) : State(initialValue: "")
        _totalVolumeS = log.totalVolume > 0 ? State(initialValue: String(log.totalVolume)) : State(initialValue: "")
        _ratingInt = State(initialValue: Int(log.rating))
        _isCompleted = State(initialValue: Bool(!log.isToDo))
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $isCompleted.animation()) {
                        Text("Task Completed!")
                            .font(.headline)
                    }.toggleStyle(CheckboxToggleStyle())
                    if isCompleted {
                        RatingView(rating: $ratingInt)
                            .font(.headline)
                        HStack {
                            Text("Comment")
                                .font(.headline)
                            TextField("Add a comment...", text: $editableLog.comment.bounds)
                                .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                Section(header: Text("Overview")) {
                    Picker("Category", selection: $editableLog.category.bounds) {
                        ForEach(Log.Category.allCases) { category in
                            Text(Log.getCategoryIcon(category)+category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onReceive(Just(editableLog.category.bounds)) { value in
                        self.updateForCategory(category: value)
                    }
                    HStack {
                        Text("Image")
                            .font(.headline)
                        Spacer()
                        editableLog.image.map({
                            UIImage(data: $0)
                                .map({
                                        Image(uiImage: $0)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .clipped()
                                            .padding(10)
                                            .onTapGesture {
                                                self.showingImageActionSheet = true
                                            }
                                })
                        })
                        Spacer()
                    }
                    HStack {
                        Text(nameFieldName)
                            .font(.headline)
                            .padding(.trailing)
                        TextField(nameFieldName, text: $editableLog.name.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                    DatePicker(dateFieldName, selection: $editableLog.activityDate.boundd, displayedComponents: .date)
                        .font(.headline)
                    Picker(selection: $editableLog.genre.bounds, label: Text("Genre").font(.headline)) {
                        switch editableLog.category {
                        case Log.Category.Book.rawValue:
                            ForEach(0 ..< bookGenre.count) {
                                Text(bookGenre[$0]).tag(bookGenre[$0])
                            }
                        case Log.Category.Task.rawValue:
                            ForEach(0 ..< taskGenre.count) {
                                Text(taskGenre[$0]).tag(taskGenre[$0])
                            }
                        case Log.Category.Exercise.rawValue:
                            ForEach(0 ..< exerciseGenre.count) {
                                Text(exerciseGenre[$0]).tag(exerciseGenre[$0])
                            }
                        default:
                            ForEach(0 ..< othersGenre.count) {
                                Text(othersGenre[$0]).tag(othersGenre[$0])
                            }

                        }
                    }

                }
                Section(header: Text("Detail Info")) {
                    HStack {
                        Text("Volume")
                            .font(.headline)
                        TextField("Done", text: $activityVolumeS)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onReceive(Just(activityVolumeS)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    activityVolumeS = filtered
                                }
                            }
                        Text("/")
                        TextField("Total", text: $totalVolumeS)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onReceive(Just(totalVolumeS)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    totalVolumeS = filtered
                                }
                            }
                        Divider()
                        TextField("Unit", text: $editableLog.volumeUnit.bounds)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Author")
                            .font(.headline)
                            .padding(.trailing)
                        TextField("Author", text: $editableLog.author.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                    HStack {
                        Text("Description")
                            .font(.headline)
                            .padding(.trailing)
                        TextField("Description", text: $editableLog.desc.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .navigationTitle("Edit Log")
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                },
                trailing:
                        SaveButton(function: {self.saveLog()})
            )
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$inputImage, isPresented: self.$showingImagePicker)
            }
            .actionSheet(isPresented: $showingImageActionSheet) { () -> ActionSheet in
                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                    self.useCamera = true
                    self.showingImagePicker = true
                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                    self.useCamera = false
                    self.showingImagePicker = true
                }), ActionSheet.Button.cancel()])
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }

        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        editableLog.image = inputImage.pngData()
        
        if useCamera {
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: inputImage)
        }
    }

    func saveLog() {
        if editableLog.name != "" {
            editableLog.activityVolume = (activityVolumeS as NSString).doubleValue
            editableLog.totalVolume = (totalVolumeS as NSString).doubleValue
            editableLog.rating = Int16(ratingInt)
            editableLog.isToDo = !isCompleted
            let newLog = Log(context: self.moc)
            newLog.updateValues(from: editableLog)
            
            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                    print("New Log: \(editableLog.name!) added.")
                } catch {
                    print(error)
                }
            }
                
        } else {
            self.showingError = true
            self.errorTitle = "Invalid Title"
            self.errorMessage = "Make sure to enter something for \nthe new item."
            return
        }

        self.presentationMode.wrappedValue.dismiss()
    }
    
    func updateForCategory(category: String) {
        switch category {
        case Log.Category.Book.rawValue: nameFieldName = "Book Name"
        case Log.Category.Task.rawValue: nameFieldName = "Task Name"
        case Log.Category.Exercise.rawValue: nameFieldName = "Exercise Name"
        case Log.Category.Cook.rawValue: nameFieldName = "Dish Name"
        default: nameFieldName = "Name"
        }
    }

}

struct EditLog_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.updatedDate = Date()
        log1.genre = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()

        return EditLog(log: log1).environment(\.managedObjectContext, context)
    }
}
