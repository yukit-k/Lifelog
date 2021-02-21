//
//  AddBook.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/01/2021.
//

import SwiftUI
import Combine
import CoreData

struct AddNewLog: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    var category: Category

    @State private var isToDo: Bool = false
    @State private var isRoutine: Bool = false

    @State private var subCategory = SubCategory(name: "")
    @State private var name = ""
    @State private var activityDate = Date()
    @State private var amount = ""
    @State private var rating: Int = 3
    @State private var comment = ""

    @State private var showDetailSection = false
    @State private var creator = ""
    @State private var description = ""

    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingImageActionSheet = false
    @State private var useCamera = false

    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingOverrideAlert = false
    
    init(category: Category) {
        if UIImage(named: "default\(category.name)Select") != nil {
            _image = State(initialValue: Image("default\(category.name)Select"))
        } else {
            _image = State(initialValue: Image("defaultOthersSelect"))
        }
        self.category = category
    }
            
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Overview")) {
                    Picker("Log Type", selection: $isToDo.animation()) {
                        Text("To Do").tag(true)
                        Text("Done").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if isToDo {
                        Toggle(isOn: $isRoutine) {
                            Text("Daily Routine")
                        }
                    }
                    DatePicker(isToDo ? isRoutine ? "From Date" : "Planned Date" : "Record Date", selection: $activityDate, displayedComponents: .date)
                    Picker("Sub Category", selection: $subCategory) {
                        ForEach(category.subCategories, id: \.self) { subCategory in
                            Text("\(subCategory.icon ?? "")\((subCategory.name))")
                                .tag(subCategory)
                        }
                    }
                    
                    HStack {
                        Text("Image")
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
                    .actionSheet(isPresented: $showingImageActionSheet) { () -> ActionSheet in
                        ActionSheet(title: Text("Choose Mode"), message: Text("Please choose the photo source"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                            self.useCamera = true
                            self.showingImagePicker = true
                        }), ActionSheet.Button.default(Text("Photo Library"), action: {
                            self.useCamera = false
                            self.showingImagePicker = true
                        }), ActionSheet.Button.cancel()])
                    }
                    TextField("Enter name", text: $name)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    
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
                            TextField("Enter amount", text: $amount)
                                .keyboardType(.numberPad)
                                .onReceive(Just(amount)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.amount = filtered
                                    }
                                }
                            Text(subCategory.unit ?? category.unit ?? "")
                        }
                        TextField("Created By", text: $creator)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        TextField("Description", text: $description)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .navigationTitle("Add \(category.icon ?? "")\(category.name)")
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
                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$inputImage)
            }
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
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
        if name == "" {
            name = "\(category.name)"
        }
        
        let newLog = Log(context: self.moc)
        newLog.id = UUID()
        newLog.isToDo = isToDo
        newLog.isRoutine = isRoutine
        newLog.category = category.name
        newLog.categoryIcon = category.icon
        newLog.name = name
        newLog.activityDate = activityDate
        if isToDo {
            newLog.rating = Int16(0)
        } else {
            newLog.rating = Int16(rating)
        }
        newLog.comment = comment
        newLog.subCategory = subCategory.name
        newLog.subCategoryIcon = subCategory.icon
        newLog.creator = creator
        newLog.desc = description
        newLog.amount = Double(amount) ?? 0
        newLog.unit = subCategory.unit ?? category.unit ?? ""
        newLog.updatedDate = Date()
        newLog.status = isToDo ? "Planned" : "Worked"
        if inputImage == nil {
            if UIImage(named: "default\(category.name)") != nil {
                inputImage = UIImage(named: "default\(category.name)")
            } else {
                inputImage = UIImage(named: "defaultOthers")
            }
        }
        let pickedItemImage = inputImage?.pngData()
        newLog.image = pickedItemImage
        
        let newMaterial = Material(context: self.moc)
        newMaterial.category = category.name
        newMaterial.categoryIcon = category.icon
        newMaterial.name = name
        newMaterial.creator = creator
        newMaterial.desc = description
        newMaterial.subCategory = subCategory.name
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
                
//        } else {
//            self.showingError = true
//            self.errorTitle = "Invalid Title"
//            self.errorMessage = "Make sure to enter something for \nthe new item."
//            return
//        }
        if isDismiss {
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.errorTitle = "Save"
            self.errorMessage = "Item saved successfully."
            self.showingError.toggle()
        }
    }
}

struct AddNewLog_Previews: PreviewProvider {
    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        return AddBook().environment(\.managedObjectContext, context)
        AddNewLog(category: Category(name: "Book", icon: "📚", unit: "page", subCategories: [
                                        SubCategory(name: "-"),
                                        SubCategory(name: "Picture Book"),
                                        SubCategory(name: "Fiction"),
                                        SubCategory(name: "Non-Fiction"),
                                        SubCategory(name: "Textbook"),
                                        SubCategory(name: "Others")]))
            .environmentObject(ModelData())
    }
}
