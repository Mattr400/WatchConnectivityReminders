//
//  WatchOS_StorybookApp.swift
//  WatchOS Storybook Watch App
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI
import WatchConnectivity
import UserNotifications
import WatchKit

@main
struct WatchOS_StorybookAppApp: App {
    let persistenceController = PersistenceController.shared.container
    let watchConnector = WatchConnector.shared
        
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Watch Notification success")
            }
        }
        WCSession.default.delegate = watchConnector
        WCSession.default.activate()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
