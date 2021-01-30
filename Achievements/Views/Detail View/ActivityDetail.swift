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
    @State private var showingDeleteAlert = false
    
    // @ObservedObject var log: Log
    var log: Log
    @State private var showingEditScreen = false
    
    let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
            geometry.frame(in: .global).minY
        }
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
            let offset = getScrollOffset(geometry)
            
            // Image was pulled down
            if offset > 0 {
                return -offset
            }
            
            return 0
        }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
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
                                            .frame(width:geometry.size.width, height:self.getHeightForHeaderImage(geometry))
                                            .clipped()
                                            .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                                })
                        })
                        
                        Text(log.wrappedGenre.uppercased())
                            .font(.caption)
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.75))
                            .clipShape(Capsule())
                            .offset(x: -5, y: self.getOffsetForHeaderImage(geometry)-5)
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
                        Text("Volume")
                            .font(.headline)
                            .padding(.trailing, 10)
                        if (log.activityVolume > 0 || log.totalVolume > 0) {
                            Text("\(log.activityVolume, specifier: "%.0f") / \(log.totalVolume, specifier: "%.0f") \(log.wrappedVolumeUnit)")
                        } else {
                            Text("Undefined")
                                .foregroundColor(.secondary)
                        }
                    }
                    HStack{
                        Text("Author")
                            .font(.headline)
                            .padding(.trailing, 10)
                        if log.wrappedAuthor != "" {
                            Text(log.wrappedAuthor)
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
        .navigationBarTitle(Text(Log.getCategoryIcon(log.wrappedCategory) + log.wrappedCategory), displayMode: .inline)
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
        log1.updatedDate = Date()
        log1.genre = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()
        return ActivityDetail(log: log1).environment(\.managedObjectContext, context)
        
    }
}
