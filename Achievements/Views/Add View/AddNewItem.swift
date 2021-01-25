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

struct AddNewItem: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var showLogSection = false
    
    let bookGenre = ["Not Selected", "Picture Book", "Fiction", "Non-Fiction", "Textbook", "Others"]
    let taskGenre = ["Not Selected", "Study", "Choir", "Hobby", "Job", "Others"]
    let exerciseGenre = ["Not Selected", "Running", "Walking", "Cycling", "Indoor", "Outdoor", "Others"]
    let othersGenre = ["Not Selected", "Others"]
    
    @State var selectedGenreIndex = 0
    @State var selectedGenre = "Not Selected"
    @State var selectedCategory = Material.Category.Book.rawValue
    @State var name = ""
    @State var createdBy = ""
    @State var description = ""
    @State var recordDate = Date()
    @State var comment = ""
    @State var totalVolume = ""
    @State var taskVolume = ""
    @State var rating: Int = 3
    @State var isToDo: Bool = false
    @State var taskUnit = ""
        
    @State var showingItemImageActionSheet = false
//    @State var showingLogImageActionSheet1 = false
//    @State var showingLogImageActionSheet2 = false
//    @State var showingLogImageActionSheet3 = false
    @State var actionSheetName: String?
    @State var useCamera = false
    
    @State var itemImage: Image? = Image("defaultBookSelect")
//    @State var logImage1: Image? = Image(systemName: "photo.on.rectangle.angled")
//    @State var logImage2: Image? = Image(systemName: "photo.on.rectangle.angled")
//    @State var logImage3: Image? = Image(systemName: "photo.on.rectangle.angled")
    @State var itemInputImage: UIImage?
//    @State var logInputImage1: UIImage?
//    @State var logInputImage2: UIImage?
//    @State var logInputImage3: UIImage?
    @State var showingItemImagePicker = false
//    @State var showingLogImagePicker1 = false
//    @State var showingLogImagePicker2 = false
//    @State var showingLogImagePicker3 = false

    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingOverrideAlert = false
    
    func getCategoryNameWithIcon(_ category: Material.Category) -> String {
        var categoryNameWithIcon: String
        switch category {
        case Material.Category.Book: categoryNameWithIcon = Material.CategoryIcon.Book.rawValue + category.rawValue
        case Material.Category.Task: categoryNameWithIcon = Material.CategoryIcon.Task.rawValue + category.rawValue
        case Material.Category.Cook: categoryNameWithIcon = Material.CategoryIcon.Cook.rawValue + category.rawValue
        case Material.Category.Exercise: categoryNameWithIcon = Material.CategoryIcon.Exercise.rawValue + category.rawValue
        default: categoryNameWithIcon = Material.CategoryIcon.Others.rawValue + category.rawValue
        }
        return categoryNameWithIcon
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("About the item")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Material.Category.allCases) { category in
                            Text(getCategoryNameWithIcon(category))
                                .tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
//                    .onReceive(Just(selectedCategory)) { value in
//                        if value == Material.Category.Book.rawValue {
//                            taskUnit = "page"
//                        }
//                    }
                    HStack {
                        Spacer()
                        itemImage?
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .padding(10)
                            .onTapGesture {
                                self.showingItemImageActionSheet = true
                            }
                        Spacer()
                    }
                    TextField("Item Name", text: $name)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Created By", text: $createdBy)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    TextField("Description", text: $description)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    HStack {
                        TextField("Total Volume", text: $totalVolume)
                            .keyboardType(.numberPad)
                            .onReceive(Just(totalVolume)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    self.totalVolume = filtered
                                }
                            }
                        Divider()
                        TextField("Unit", text: $taskUnit)
                            .keyboardType(.default)
                    }
                    Picker(selection: $selectedGenre, label: Text("Genre")) {
                        switch selectedCategory {
                        case Material.Category.Book.rawValue:
                            ForEach(0 ..< bookGenre.count) {
                                Text(bookGenre[$0]).tag(bookGenre[$0])
                            }
                        case Material.Category.Task.rawValue:
                            ForEach(0 ..< taskGenre.count) {
                                Text(taskGenre[$0]).tag(taskGenre[$0])
                            }
                        case Material.Category.Exercise.rawValue:
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
                Section() {
                    Toggle(isOn: $showLogSection) {
                        Text("Add an Activity Log")
                    }
                }
                if showLogSection {
                    Section(header: Text("Activity Log")) {
                        DatePicker("Acitivity Date", selection: $recordDate, displayedComponents: .date)
                        HStack {
                            TextField("Task Volume", text: $taskVolume)
                                .keyboardType(.numberPad)
                                .onReceive(Just(taskVolume)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.taskVolume = filtered
                                    }
                                }
                            Text("\(taskUnit)(s)")
                                .foregroundColor(.secondary)

                        }
                        
                        Toggle(isOn: $isToDo) {
                            Text("To Do")
                        }
                        
                        if !isToDo {
                            RatingView(rating: $rating)
                            TextField("Add a comment...", text: $comment)
                                .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        }
    //                    HStack {
    //                        Text("Log Image")
    //                        Spacer()
    //                        logImage1?
    //                            .resizable()
    //                            .scaledToFit()
    //                            .frame(height: 30)
    //                            .padding(5)
    //                            .foregroundColor(.secondary)
    //                            .onTapGesture {
    //                                self.showingLogImageActionSheet1 = true
    //                            }
    //                            .sheet(isPresented: $showingLogImagePicker1, onDismiss: loadLogImage1) {
    //                                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$logInputImage1, isPresented: self.$showingLogImagePicker1)
    //                            }
    //                            .actionSheet(isPresented: $showingLogImageActionSheet1) { () -> ActionSheet in
    //                                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
    //                                    self.useCamera = true
    //                                    self.showingLogImagePicker1 = true
    //                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
    //                                    self.useCamera = false
    //                                    self.showingLogImagePicker1 = true
    //                                }), ActionSheet.Button.cancel()])
    //                            }
    //                        logImage2?
    //                            .resizable()
    //                            .scaledToFit()
    //                            .frame(height: 30)
    //                            .padding(5)
    //                            .foregroundColor(.secondary)
    //                            .onTapGesture {
    //                                self.showingLogImageActionSheet2 = true
    //                            }
    //                            .sheet(isPresented: $showingLogImagePicker2, onDismiss: loadLogImage2) {
    //                                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$logInputImage2, isPresented: self.$showingLogImagePicker2)
    //                            }
    //                            .actionSheet(isPresented: $showingLogImageActionSheet2) { () -> ActionSheet in
    //                                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
    //                                    self.useCamera = true
    //                                    self.showingLogImagePicker2 = true
    //                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
    //                                    self.useCamera = false
    //                                    self.showingLogImagePicker2 = true
    //                                }), ActionSheet.Button.cancel()])
    //                            }
    //                        logImage3?
    //                            .resizable()
    //                            .scaledToFit()
    //                            .frame(height: 30)
    //                            .padding(5)
    //                            .foregroundColor(.secondary)
    //                            .onTapGesture {
    //                                self.showingLogImageActionSheet2 = true
    //                            }
    //                            .sheet(isPresented: $showingLogImagePicker3, onDismiss: loadLogImage3) {
    //                                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$logInputImage3, isPresented: self.$showingLogImagePicker3)
    //                            }
    //                            .actionSheet(isPresented: $showingLogImageActionSheet3) { () -> ActionSheet in
    //                                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
    //                                    self.useCamera = true
    //                                    self.showingLogImagePicker3 = true
    //                                }), ActionSheet.Button.default(Text("Photo Library"), action: {
    //                                    self.useCamera = false
    //                                    self.showingLogImagePicker3 = true
    //                                }), ActionSheet.Button.cancel()])
    //                            }
    //                    }
                    }
                }
                HStack {
                    Spacer()
                    Button("Save") {
                        if self.isDuplicateMaterial(name: self.name) {
                            self.showingOverrideAlert = true
                        } else {
                            self.saveBook()
                        }
                    }
                    .alert(isPresented: $showingOverrideAlert) {
                        Alert(title: Text("Override existing material"),
                              message: Text("The same material already exist. Do you want to override it?"),
                              primaryButton: .default(Text("Save")) {
                                self.saveBook()
                              }, secondaryButton: .cancel())
                    }
                    Spacer()
                }
            }
            .navigationTitle("Add New Item")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
            .sheet(isPresented: $showingItemImagePicker, onDismiss: loadItemImage) {
                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$itemInputImage, isPresented: self.$showingItemImagePicker)
            }
            .actionSheet(isPresented: $showingItemImageActionSheet) { () -> ActionSheet in
                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                    self.useCamera = true
                    self.showingItemImagePicker = true
                }), ActionSheet.Button.default(Text("Photo Library"), action: {
                    self.useCamera = false
                    self.showingItemImagePicker = true
                }), ActionSheet.Button.cancel()])
            }

//            .actionSheet(isPresented: $showingImageActionSheet) { () -> ActionSheet in
//                ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
//                    self.useCamera = true
//                    switch self.actionSheetName {
//                    case "ItemImage": self.showingItemImagePicker = true
//                    case "LogImage1": self.showingLogImagePicker1 = true
//                    case "LogImage2": self.showingLogImagePicker2 = true
//                    case "LogImage3": self.showingLogImagePicker3 = true
//                    default: print("Invalid actionSheetName")
//                    }
//                }), ActionSheet.Button.default(Text("Photo Library"), action: {
//                    self.useCamera = false
//                    switch self.actionSheetName {
//                    case "ItemImage": self.showingItemImagePicker = true
//                    case "LogImage1": self.showingLogImagePicker1 = true
//                    case "LogImage2": self.showingLogImagePicker2 = true
//                    case "LogImage3": self.showingLogImagePicker3 = true
//                    default: print("Invalid actionSheetName")
//                    }
//                }), ActionSheet.Button.cancel()])
//            }
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func loadItemImage() {
        guard let itemInputImage = itemInputImage else { return }
        itemImage = Image(uiImage: itemInputImage)
        
//        UIImageWriteToSavedPhotosAlbum(itemInputImage, nil, nil, nil)
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: itemInputImage)
    }
//    func loadLogImage1() {
//        guard let logInputImage1 = logInputImage1 else { return }
//        logImage1 = Image(uiImage: logInputImage1)
//    }
//    func loadLogImage2() {
//        guard let logInputImage2 = logInputImage2 else { return }
//        logImage2 = Image(uiImage: logInputImage2)
//    }
//    func loadLogImage3() {
//        guard let logInputImage3 = logInputImage3 else { return }
//        logImage3 = Image(uiImage: logInputImage3)
//    }
    
    func isDuplicateMaterial(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let duplicateMaterials = try moc.fetch(fetchRequest) as [Material]
            return duplicateMaterials.count > 0 ? true : false
        } catch {
            print(error)
        }
        return false
    }
    
    func saveBook() {
        if name != "" {
            if showLogSection {
                let newBookLog = Log(context: self.moc)
                newBookLog.recordDate = recordDate
                newBookLog.taskVolume = Double(totalVolume) ?? 1
                newBookLog.isToDo = isToDo
                if isToDo {
                    newBookLog.comment = ""
                    newBookLog.rating = Int16(0)
                } else {
                    newBookLog.comment = comment
                    newBookLog.rating = Int16(rating)
                }
    //            let pickedLogImage1 = logInputImage1?.pngData()
    //            newBookLog.image1 = pickedLogImage1
    //            let pickedLogImage2 = logInputImage2?.pngData()
    //            newBookLog.image2 = pickedLogImage2
    //            let pickedLogImage3 = logInputImage3?.pngData()
    //            newBookLog.image3 = pickedLogImage3
                newBookLog.material = Material(context: self.moc)
                newBookLog.material?.category = selectedCategory
                newBookLog.material?.name = name
                newBookLog.material?.createdBy = createdBy
                newBookLog.material?.desc = description
                newBookLog.material?.totalVolume = Double(totalVolume) ?? 1
                newBookLog.material?.taskUnit = taskUnit
                newBookLog.material?.genre = selectedGenre
                newBookLog.material?.updateDate = Date()
                newBookLog.material?.version = "1.0"
                newBookLog.material?.status = isToDo ? "Planned" : "Worked"
                if itemInputImage == nil {
                    if selectedCategory == Material.Category.Book.rawValue {
                        itemInputImage = UIImage(named: "defaultBook")
                    }
                }
                let pickedItemImage = itemInputImage?.pngData()
                newBookLog.material?.image = pickedItemImage
            } else {
                let newMaterial = Material(context: self.moc)
                newMaterial.category = selectedCategory
                newMaterial.name = name
                newMaterial.createdBy = createdBy
                newMaterial.desc = description
                newMaterial.totalVolume = Double(totalVolume) ?? 1
                newMaterial.genre = selectedGenre
                newMaterial.updateDate = Date()
                newMaterial.version = "1.0"
                newMaterial.status = "Open"
                if itemInputImage == nil {
                    if selectedCategory == Material.Category.Book.rawValue {
                        itemInputImage = UIImage(named: "defaultBook")
                    }
                }
                let pickedItemImage = itemInputImage?.pngData()
                newMaterial.image = pickedItemImage
            }
            
            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                    print("New Book: \(self.name) added.")
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
}

struct AddNewItem_Previews: PreviewProvider {
    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return AddBook().environment(\.managedObjectContext, context)
        AddNewItem()
    }
}
