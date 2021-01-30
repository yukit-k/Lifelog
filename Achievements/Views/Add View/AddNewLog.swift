//
//  AddBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/01/2021.
//

import SwiftUI
import Combine
import Foundation
import CoreData

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save to Photo Library finished")
    }
}

struct AddNewLog: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var isToDo: Bool = false
    @State private var viewTitle: String = ""
    @State private var dateFieldName: String = ""
    @State private var nameFieldName: String = "Name"
    
    @State private var showDetailSection = false
    
    let bookGenre = ["Not Selected", "Picture Book", "Fiction", "Non-Fiction", "Textbook", "Others"]
    let taskGenre = ["Not Selected", "Study", "Choir", "Hobby", "Job", "Others"]
    let exerciseGenre = ["Not Selected", "Running", "Walking", "Cycling", "Indoor", "Outdoor", "Others"]
    let cookGenre = ["Not Selected", "Dinner", "Lunch", "Breakfast", "Desert", "Others"]
    let othersGenre = ["Not Selected", "Others"]
    
    @State private var selectedGenreIndex = 0
    @State private var selectedGenre = "Not Selected"
    @State private var selectedCategory = Log.Category.Book.rawValue
    @State private var name = ""
    @State private var author = ""
    @State private var description = ""
    @State private var activityDate = Date()
    @State private var comment = ""
    @State private var totalVolume = ""
    @State private var activityVolume = ""
    @State private var rating: Int = 3
    @State private var volumeUnit = ""
            
    @State private var image: Image? = Image("defaultBookSelect")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingImageActionSheet = false
    @State private var useCamera = false

    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingOverrideAlert = false
    
    init(isToDo: Bool) {
        if isToDo {
            _viewTitle = State(initialValue: "Add To-Do")
            _dateFieldName = State(initialValue: "Planned Date")
        } else {
            _viewTitle = State(initialValue: "Add Log")
            _dateFieldName = State(initialValue: "Record Date")
        }
        _isToDo = State(initialValue: isToDo)
    }
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Overview")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Log.Category.allCases) { category in
                            Text(Log.getCategoryIcon(category)+category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onReceive(Just(selectedCategory)) { value in
                        self.updateForCategory(category: value)
                    }
                    HStack {
                        Spacer()
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped()
                            .padding(10)
                            .onTapGesture {
                                self.showingImageActionSheet = true
                            }
                        Spacer()
                    }
                    TextField(nameFieldName, text: $name)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    DatePicker(dateFieldName, selection: $activityDate, displayedComponents: .date)
                    Picker(selection: $selectedGenre, label: Text("Genre")) {
                        switch selectedCategory {
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
                    if !isToDo {
                        RatingView(rating: $rating)
                        TextField("Add a comment...", text: $comment)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }

                }
                Section(header: Text("Detail Info")) {
                    Toggle(isOn: $showDetailSection.animation()) {
                        Text("Add Details")
                    }
                    if showDetailSection {
                        HStack {
                            TextField("Volume", text: $activityVolume)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .onReceive(Just(activityVolume)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.activityVolume = filtered
                                    }
                                }
                            Text("/")
                            TextField("Total", text: $totalVolume)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .onReceive(Just(totalVolume)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.totalVolume = filtered
                                    }
                                }
                            Divider()
                            TextField("Unit", text: $volumeUnit)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }

                        TextField("Author", text: $author)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        TextField("Description", text: $description)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                }
//                HStack {
//                    Spacer()
//                    Button("Save") {
//                        self.saveLog()
////                        if self.isDuplicateMaterial(name: self.name) {
////                            self.showingOverrideAlert = true
////                        } else {
////                            self.saveBook()
////                        }
//                    }
////                    .alert(isPresented: $showingOverrideAlert) {
////                        Alert(title: Text("Override existing material"),
////                              message: Text("The same material already exist. Do you want to override it?"),
////                              primaryButton: .default(Text("Save")) {
////                                self.saveBook()
////                              }, secondaryButton: .cancel())
////                    }
//                    Spacer()
//                }
            }
            .navigationTitle(viewTitle)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                },
                trailing:
                    HStack {
                        SaveContinueButton(function: {self.saveLog(isDismiss: false)})
                        SaveButton(function: {self.saveLog(isDismiss: true)})
                    }
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
        image = Image(uiImage: inputImage)
        
        if useCamera {
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: inputImage)
        }
    }
    
//    func isDuplicateMaterial(name: String) -> Bool {
//        let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        do {
//            let duplicateMaterials = try moc.fetch(fetchRequest) as [Material]
//            return duplicateMaterials.count > 0 ? true : false
//        } catch {
//            print(error)
//        }
//        return false
//    }
    
    func saveLog(isDismiss: Bool) {
        if name != "" {
            let newLog = Log(context: self.moc)
            newLog.id = UUID()
            newLog.isToDo = isToDo
            newLog.category = selectedCategory
            newLog.name = name
            newLog.activityDate = activityDate
            if isToDo {
                newLog.rating = Int16(0)
            } else {
                newLog.rating = Int16(rating)
            }
            newLog.comment = comment
            newLog.genre = selectedGenre
            newLog.author = author
            newLog.desc = description
            newLog.totalVolume = Double(totalVolume) ?? 0
            newLog.activityVolume = Double(activityVolume) ?? 0
            newLog.volumeUnit = volumeUnit
            newLog.updatedDate = Date()
            newLog.status = isToDo ? "Planned" : "Worked"
            if inputImage == nil {
                switch selectedCategory {
                case Log.Category.Book.rawValue: inputImage = UIImage(named: "defaultBook")
                case Log.Category.Task.rawValue: inputImage = UIImage(named: "defaultTask")
                case Log.Category.Exercise.rawValue: inputImage = UIImage(named: "defaultExercise")
                case Log.Category.Cook.rawValue: inputImage = UIImage(named: "defaultCook")
                default: inputImage = UIImage(named: "defaultOthers")
                }
            }
            let pickedItemImage = inputImage?.pngData()
            newLog.image = pickedItemImage
            
            let newMaterial = Material(context: self.moc)
            newMaterial.category = selectedCategory
            newMaterial.name = name
            newMaterial.author = author
            newMaterial.desc = description
            newMaterial.totalVolume = Double(totalVolume) ?? 1
            newMaterial.genre = selectedGenre
            newMaterial.updatedDate = Date()
            newMaterial.version = "1.0"
            newMaterial.status = "Open"
            newMaterial.image = pickedItemImage
            
            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                    print("New Log: \(name) added.")
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
        if isDismiss {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateForCategory(category: String) {
        if inputImage == nil {
            switch category {
            case Log.Category.Book.rawValue: image = Image("defaultBookSelect")
            case Log.Category.Task.rawValue: image = Image("defaultTaskSelect")
            case Log.Category.Exercise.rawValue: image = Image("defaultExerciseSelect")
            case Log.Category.Cook.rawValue: image = Image("defaultCookSelect")
            default: image = Image("defaultOthersSelect")
            }
        }
        switch category {
        case Log.Category.Book.rawValue: nameFieldName = "Book Name"
        case Log.Category.Task.rawValue: nameFieldName = "Task Name"
        case Log.Category.Exercise.rawValue: nameFieldName = "Exercise Name"
        case Log.Category.Cook.rawValue: nameFieldName = "Dish Name"
        default: nameFieldName = "Name"
        }
    }
}

struct AddNewLog_Previews: PreviewProvider {
    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return AddBook().environment(\.managedObjectContext, context)
        AddNewLog(isToDo: false)
    }
}
