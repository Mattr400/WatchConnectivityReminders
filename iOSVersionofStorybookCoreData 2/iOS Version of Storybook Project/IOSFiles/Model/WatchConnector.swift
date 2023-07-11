//
//  WatchConnector.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/12/23.
//


import WatchConnectivity
import CoreData

final class WatchConnector: NSObject, WCSessionDelegate {

    static let shared  = WatchConnector()
    let persistentContainer: NSPersistentContainer

   private override init() {
       persistentContainer = PersistenceController.shared.container
       super.init()

       if WCSession.isSupported() {
           WCSession.default.delegate = self
           WCSession.default.activate()
       }
    }
    
    
    func session(_ session: WCSession,activationDidCompleteWith activationState: WCSessionActivationState, error : Error?){
        print("session activated")
    }
    
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // if user has more than one watch, and they switch,
        // reactivate their session on the new device
        session.activate()
    }
#endif
    
    
   
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let action = message["action"] as? String {
            if action == "create" {
                // Handle reminder creation
                guard let title = message["title"] as? String,
                      let dateAdded = message["dateAdded"] as? Date,
                      let identifier = message["identifier"] as? String else {
                    return
                }
                
                let newReminder = Reminders(context: persistentContainer.viewContext)
                newReminder.title = title
                newReminder.dateAdded = dateAdded
                newReminder.identifier = identifier
                 // Set the identifier for the new reminder
                
                do {
                    try persistentContainer.viewContext.save()
                    print("Created reminder added")
                } catch {
                    print("Failed to save new reminder in watchOS app: \(error.localizedDescription)")
                }
            } else if action == "delete" {
                                // Handle reminder deletion
                                guard let identifierString = message["identifier"] as? String else {
                                    return
                                }
                                
                                // Construct objectID from identifier string
                                guard let identifierURL = URL(string: identifierString),
                                      let objectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: identifierURL),
                                      let existingReminder = try? persistentContainer.viewContext.existingObject(with: objectID) as? Reminders else {
                                    return
                                }
                                
                                // Print the reminder that will be deleted
                                print("Deleting Reminder: \(existingReminder.title ?? "")")
                                
                                // Delete the reminder locally
                                persistentContainer.viewContext.delete(existingReminder)
                                
                                do {
                                    try persistentContainer.viewContext.save()
                                    
                                    // Print a success message after deletion
                                    print("Reminder deleted successfully")
                                    
                                    // Send a message or update application context to notify the other device about the deletion
                                    // ...
                                    
                                } catch {
                                    print("Failed to save context after receiving reminder deletion message: \(error.localizedDescription)")
                                }
                            }
                 else if action == "edit" {
                                // Handle reminder editing
                                if let identifierString = message["identifier"] as? NSManagedObjectID,
                                   let title = message["title"] as? String {

                                    // Fetch the existing reminder from Core Data using the identifier
                                    guard let existingReminder = try? persistentContainer.viewContext.existingObject(with: identifierString) as? Reminders else {
                                        print("Reminder not found in Core Data")
                                        return
                                    }

                                    // Update the existing reminder with the
                    // Save the updated reminder
                    do {
                        try persistentContainer.viewContext.save()
                        print("Updated reminder title: \(existingReminder.title ?? "")")
                    } catch {
                        print("Failed to save updated reminder: \(error.localizedDescription)")
                    }
                }
            }
        }
        
     
   
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
            // Handle the received application context here
        if let action = applicationContext["action"] as? String {
            if action == "delete" {
                // Handle reminder deletion
                guard let identifierString = applicationContext["identifier"] as? String else {
                    return
                }
                
                // Construct objectID from identifier string
                guard let identifierURL = URL(string: identifierString),
                      let objectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: identifierURL),
                      let existingReminder = try? persistentContainer.viewContext.existingObject(with: objectID) as? Reminders else {
                    return
                }
                
                // Print the reminder that will be deleted
                print("Deleting Reminder: \(existingReminder.title ?? "")")
                
                // Delete the reminder locally
                persistentContainer.viewContext.delete(existingReminder)
                
                do {
                    try persistentContainer.viewContext.save()
                    
                    // Print a success message after deletion
                    print("Reminder deleted successfully")
                    
                    // Send a message or update application context to notify the other device about the deletion
                    // ...
                    
                } catch {
                    print("Failed to save context after receiving reminder deletion message: \(error.localizedDescription)")
                }
            }
            else if action == "edit" {
                // Handle reminder editing
                if let identifierString = applicationContext["identifier"] as? NSManagedObjectID,
                   let title = applicationContext["title"] as? String {
                    
                    // Fetch the existing reminder from Core Data using the identifier
                    guard let existingReminder = try? persistentContainer.viewContext.existingObject(with: identifierString) as? Reminders else {
                        print("Reminder not found in Core Data")
                        return
                    }
                    
                    print("Existing reminder title: \(existingReminder.title ?? "")")
                    // Update the existing reminder with the
                    // Save the updated reminder
                    existingReminder.title = title
                    print("Existing reminder new title: \(existingReminder.title ?? "")")
                    do {
                        try persistentContainer.viewContext.save()
                        print("Updated reminder title: \(existingReminder.title ?? "")")
                    } catch {
                        print("Failed to save updated reminder: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


 






