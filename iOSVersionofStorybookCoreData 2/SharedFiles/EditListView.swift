//
//  EditListView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI
import CoreData
import UserNotifications
import WatchConnectivity

struct EditListView: View {
    
    //    @FetchRequest(entity: Reminders.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Reminders.dateAdded, ascending: false)], animation: .easeIn) var results: FetchedResults<Reminders>
    //
    @FetchRequest(entity: Reminders.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Reminders.dateAdded, ascending: false)], animation: .easeIn) var results: FetchedResults<Reminders>
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var remindersUpdated = false
    
    var body: some View {
        List(results) { item in
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                    
                    Text("Last Modified")
                        .font(.system(size: 8))
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Text(item.dateAdded ?? Date(), style: .date)
                        .font(.system(size: 8))
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                Spacer(minLength: 4)
                
                NavigationLink(destination: Edit_DeleteView(remindItem: item)) {
                    Image(systemName: "pencil.circle")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(DefaultListStyle())
        .onAppear {
            print("Number of reminders: \(results.count)")
        }
        .overlay(
            Text(results.isEmpty ? "No Reminders Created" : "")
        )
        
        //        if !results.isEmpty {
        //            Button(action: deleteAllReminders) {
        //                Text("Delete All")
        //                    .font(.system(size: 14))
        //                    .foregroundColor(.white)
        //                    .padding()
        //                    .background(Color.red)
        //                    .cornerRadius(8)
        //            }
        //            .padding()
        //        }
        //    }
        //
        //
        //    private func deleteAllReminders() {
        //          for reminder in results {
        //              viewContext.delete(reminder)
        //          }
        //
        //          do {
        //              try viewContext.save()
        //          } catch {
        //              print("Failed to delete reminders: \(error.localizedDescription)")
        //          }
        //      }
        
        
        
    }
    struct EditListView_Previews: PreviewProvider {
        static var previews: some View {
            EditListView()
        }
    }

}
