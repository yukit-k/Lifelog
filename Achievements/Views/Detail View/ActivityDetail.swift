//
//  BookDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//

import SwiftUI
import CoreData

struct ActivityDetail: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    @State private var showingDeleteAlert = false
    
    // @ObservedObject var log: Log
    var log: Log
    @State private var showingEditScreen = false
    
    let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    let imageHelper = ImageHelper()
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomTrailing) {
                        log.image.map({
                            UIImage(data: $0)
                                .map({
                                        Image(uiImage: $0)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:geometry.size.width, height:imageHelper.getHeightForHeaderImage(geometry))
                                            .clipped()
                                            .offset(x: 0, y: imageHelper.getOffsetForHeaderImage(geometry))
                                })
                        })
                        
                        Text(log.wrappedSubCategory.uppercased())
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: imageHelper.getOffsetForHeaderImage(geometry)-5)
                    }
                }
                .frame(height: 300)

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                            Text(log.wrappedName)
                                .font(.title)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(log.wrappedActivityDate, formatter: self.logDateFormat)")
                                .font(.headline)
                                .padding(.trailing, 5)
                            if log.isToDo {
                                Text(" To Do ")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(4)
                                    .foregroundColor(.white)
                                    .background(Color.orange.opacity(0.85))
                                    .clipShape(Capsule())
                            } else {
                                Text(" Done ")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(4)
                                    .foregroundColor(.white)
                                    .background(Color.green.opacity(0.85))
                                    .clipShape(Capsule())

                            }
                    }
                    if (log.amount > 0) {
                        Text("\(log.amount, specifier: "%.0f") \(log.wrappedUnit)")
                    }

                    if !log.isToDo {
                        RatingView(rating: .constant(Int(log.rating)))
                            .font(.headline)
                        HStack {
                            Text("Comment")
                                .font(.headline)
                                .padding(.trailing, 10)
                            if log.wrappedComment != "" {
                                Text(log.wrappedComment)
                            } else {
                                Text("No comment")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    Divider()
                        .padding(.top)
                    HStack{
                        Text("Created by")
                            .font(.headline)
                            .padding(.trailing, 10)
                        if log.wrappedCreator != "" {
                            Text(log.wrappedCreator)
                        } else {
                            Text("Undefined")
                                .foregroundColor(.secondary)
                        }
                    }
                    HStack{
                        Text("Description")
                            .font(.headline)
                            .padding(.trailing, 10)
                        if log.wrappedDesc != "" {
                            Text(log.wrappedDesc)
                        } else {
                            Text("No description")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }
        }
        .navigationBarTitle(Text("\(log.wrappedCategory) Detail"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")){
                    self.deleteLog()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.showingEditScreen.toggle()
                                }) {
                                    Text("Edit")
        })
        .sheet(isPresented: $showingEditScreen) {
            EditLog(log: self.log)
                .environmentObject(modelData)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
    
    func deleteLog() {
        moc.delete(log)
        if self.moc.hasChanges {
            do {
                try self.moc.save()
                print("Delete Log Completed.")
            } catch {
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct ActivityDetail_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.subCategory = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()
        log1.updatedDate = Date()
        return ActivityDetail(log: log1).environment(\.managedObjectContext, context)
        
    }
}
