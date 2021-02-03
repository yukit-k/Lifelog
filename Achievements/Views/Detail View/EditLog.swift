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
    @EnvironmentObject var modelData: ModelData

    @State private var editableLog: EditableLogData
    @State private var amountString: String = ""
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

    init(log: Log) {
        _editableLog = State(initialValue: EditableLogData(from: log))
        _amountString = log.amount > 0 ? State(initialValue: String(log.amount)) : State(initialValue: "")
        _ratingInt = State(initialValue: Int(log.rating))
        _isCompleted = State(initialValue: Bool(!log.isToDo))
    }
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Log")) {
                    Toggle(isOn: $isCompleted.animation()) {
                        Text("Task Completed!")
                            .font(.headline)
                    }.toggleStyle(CheckboxToggleStyle())
                    if isCompleted {
                        RatingView(rating: $ratingInt)
                        HStack {
                            Text("Comment")
                                .padding(.trailing)
                            TextField("Add a comment...", text: $editableLog.comment.bounds)
                                .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                Section(header: Text("Overview")) {
                    DatePicker(isCompleted ? "Record Date" : "Planned Date", selection: $editableLog.activityDate.boundd, displayedComponents: .date)
                    HStack {
                        Text("Name")
                            .padding(.trailing)
                        TextField("Name", text: $editableLog.name.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                    Picker(selection: $editableLog.category.bounds, label: Text("Category")) {
                        ForEach(modelData.userSettings.categories, id: \.self) { category in
                            Text("\(category.icon ?? "") \(category.name)")
                                .tag(category.name)
                        }
                    }
//                    .onReceive(Just(editableLog.category.bounds)) { value in
//                        self.updateForCategory(category: value)
//                    }
                    Picker(selection: $editableLog.subCategory.bounds, label: Text("Sub Category")) {
                        ForEach(modelData.userSettings.categories.first(where: {$0.name == editableLog.category})?.subCategories ?? []) { subCategory in
                            Text("\(subCategory.icon ?? "") \(subCategory.name)")
                                .tag(subCategory.name)
                        }
                    }
                    HStack {
                        Text("Amount")
                            .padding(.trailing)
                        TextField("Add amount...", text: $amountString)
                            .keyboardType(.numberPad)
                            .onReceive(Just(amountString)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    amountString = filtered
                                }
                            }
                        Text(editableLog.unit.bounds)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Image")
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
                }
                Section(header: Text("Detail")) {
                    HStack {
                        Text("Created by")
                            .padding(.trailing)
                        TextField("Add creator..", text: $editableLog.creator.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                    HStack {
                        Text("Description")
                            .padding(.trailing)
                        TextField("Add description...", text: $editableLog.desc.bounds)
                            .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .navigationTitle("Edit \(editableLog.categoryIcon ?? "")\(editableLog.category ?? "") Log")
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
                ImagePicker(sourceType: self.useCamera ? .camera : .photoLibrary, image: self.$inputImage)
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
        if editableLog.name == "" {
            editableLog.name = "New \(editableLog.category ?? "Item") (\(editableLog.subCategory ?? ""))"
        }
        editableLog.amount = (amountString as NSString).doubleValue
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
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditLog_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.updatedDate = Date()
        log1.subCategory = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()

        return EditLog(log: log1)
            .environment(\.managedObjectContext, context)
            .environmentObject(ModelData())
    }
}
