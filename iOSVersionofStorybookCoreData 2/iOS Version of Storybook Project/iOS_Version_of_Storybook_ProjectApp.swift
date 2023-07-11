//
//  iOS_Version_of_Storybook_ProjectApp.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI
import UserNotifications
import WatchConnectivity

@main
struct iOS_Version_of_Storybook_ProjectApp: App {
    let persistenceController = PersistenceController.shared.container
    let watchConnector = WatchConnector.shared
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("iOS Notification success")
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
