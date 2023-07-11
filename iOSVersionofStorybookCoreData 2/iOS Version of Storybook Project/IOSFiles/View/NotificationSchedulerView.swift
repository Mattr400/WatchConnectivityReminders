//
//  NotificationSchedulerView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI
import UserNotifications

struct NotificationSchedulerView: View {
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var isNotificationScheduled = false
    @State private var isAM = true
    @State private var amPmSelection = 0
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedHour, label: Text("Hour")) {
                    ForEach(0..<12) { hour in
                        Text("\(hour == 0 ? 12 : hour)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 70)
                .clipped()
                
                Text(":")
                    .font(.title)
                
                Picker(selection: $selectedMinute, label: Text("Minute")) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 70)
                .clipped()
            }
            
            Picker(selection: $amPmSelection, label: Text("AM/PM")) {
                Text("AM").tag(0)
                Text("PM").tag(1)
            }
            .pickerStyle(.wheel)
            .frame(width: 60, height: 60)
            .clipped()
            .onChange(of: amPmSelection) { newValue in
                isAM = (newValue == 0)
            }
            
            Button(action: {
                scheduleNotification()
            }) {
                Text("Set Alarm")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        
        }
    }
    
    private func scheduleNotification() {
        let hour = selectedHour + (isAM ? 0 : 12)
        let minute = selectedMinute
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Sleep like a baby!"
        content.body = "This is the perfect moment for your daily massage"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
                isNotificationScheduled = true
                dismiss()
            }
        }
    }

}

struct NotificationSchedulerView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSchedulerView()
    }
}

