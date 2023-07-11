//
//  Edit_DeleteView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//
import SwiftUI
import CoreData
import UserNotifications
import WatchConnectivity

struct Edit_DeleteView: View {
    @FetchRequest(entity: Reminders.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Reminders.dateAdded, ascending: false)], animation: .easeIn) var results: FetchedResults<Reminders>
    
    @State private var editedTitle: String = ""
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) private var dismiss
    
    var remindItem: Reminders?
    
    @State var deleteReminderItem: Reminders?
    @State var showAlert = false
    
    @State private var isShowingNotificationScheduler = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                TextField("Bedtime...", text: $editedTitle)
                Button(action: saveChanges) {
                    Text("Save")
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.orange)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .buttonStyle(PlainButtonStyle())
                .disabled(editedTitle.isEmpty)
                
                Button(action: {
                    deleteReminderItem = remindItem
                    showAlert = true
                }) {
                    Text("Delete")
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .buttonStyle(PlainButtonStyle())
                .disabled(editedTitle.isEmpty)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm"),
                        message: Text("Delete this reminder?"),
                        primaryButton: .destructive(Text("Delete"), action: deleteReminder),
                        secondaryButton: .cancel()
                    )
                }
                
                Button(action: {                    isShowingNotificationScheduler = true
                }) {
                    Text("Schedule Notification")
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .buttonStyle(PlainButtonStyle())
                .disabled(editedTitle.isEmpty)
            }
            .sheet(isPresented: $isShowingNotificationScheduler) {
                NotificationSchedulerView()
            }
            .onAppear {
                editedTitle = remindItem!.title ?? ""
            }
        }
    }
    
    private func saveChanges() {
        let reminders = remindItem == nil ? Reminders(context: context) : remindItem!

        reminders.title = editedTitle
        reminders.dateAdded = Date()
        reminders.identifier = "x-coredata://Reminders/\(reminders.objectID.uriRepresentation().absoluteString)"
           
    
        do {
            try context.save()
            if WCSession.default.activationState == .activated && WCSession.default.isReachable {
                let message: [String: Any] = [
                    "action": "edit",
                    "identifier": reminders.identifier ?? "",
                    "title": reminders.title ?? ""
                ]
                
                WCSession.default.sendMessage(message, replyHandler: nil) { error in
                    print("Failed to send reminder data: \(error.localizedDescription)")
                }
                
                // Update the application context
                          let applicationContext: [String: Any] = [
                              "action": "edit",
                              "identifier": reminders.identifier ?? "",
                              "title" : reminders.title ?? ""
                          ]
                          
                try WCSession.default.updateApplicationContext(applicationContext)
                          
            }
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
       }
    
    func deleteReminder() {
        if let reminder = deleteReminderItem {
            // Send a message or update application context to notify the other device about the deletion
            // Delete the reminder locally
            context.delete(reminder)
            
            do {
                try context.save()
                if WCSession.default.activationState == .activated && WCSession.default.isReachable {
                    let message: [String: Any] = [
                        "action": "delete",
                        "identifier": reminder.identifier ?? ""
                    ]
                    
                    WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
                        print("Failed to send reminder deletion message: \(error.localizedDescription)")
                    })
                }
                dismiss()
            } catch {
                print("Failed to save context after deleting reminder: \(error.localizedDescription)")
            }
        }
    }

}


