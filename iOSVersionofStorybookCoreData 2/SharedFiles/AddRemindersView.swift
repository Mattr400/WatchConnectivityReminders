//
//  AddRemindersView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI
import WatchConnectivity

struct AddRemindersView: View {
    
    @State var remindText = ""
    
    //getting context from Environment
    @Environment(\.managedObjectContext) var context
    
    //dismiss View after Saving
    @Environment(\.dismiss) private var dismiss
    
    //Edit Options
    var remindItem: Reminders?
    
    
    var body: some View {
            VStack{
                    TextField("Bedtime...", text: $remindText)
                    .padding(15)
                        .background(Color.gray.opacity(0.3).cornerRadius(10))
                        .font(.headline)
                       
                    
                    Button(action: addReminder, label: {
                        Text("Save")
                            .font(.title.bold())
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .cornerRadius(15)
                    })
                    .padding(.horizontal)
                    .buttonStyle(SaveButton())
                    .disabled(remindText == "")
                }
                .onAppear(perform: {
                    if let remind = remindItem{
                        remindText = remind.title ?? ""
                }
            })
        }
    
    func addReminder() {

        let reminders =  remindItem == nil ? Reminders(context: context) : remindItem!

          reminders.title = remindText
          reminders.dateAdded = Date()

        //Save
        do{
            try context.save()
            if WCSession.default.activationState == .activated && WCSession.default.isReachable {
                let reminderData: [String: Any] = [
                    "action": remindItem == nil ? "create" : "edit",
                    "identifier": reminders.objectID.uriRepresentation().absoluteString,
                    "title": reminders.title!,
                    "dateAdded": reminders.dateAdded!
                ]

                WCSession.default.sendMessage(reminderData, replyHandler: nil) { error in
                                print("Failed to send reminder data: \(error.localizedDescription)")
                            }
            }
            dismiss()
        }
        catch{
            print(error.localizedDescription)
        }
    }

    


}

struct AddRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        AddRemindersView()
    }
}
