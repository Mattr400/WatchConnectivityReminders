//
//  RemindersView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI

struct RemindersView: View {
    @State private var isSheetPresented = false
    var body: some View {
        //Geometry Reader For Options Frame
        VStack(spacing: 15) {
            
            HStack {
                Button(action: { isSheetPresented = true
                }) {
                    Text("Add Reminder")
                }
                .buttonStyle(AddReminderButton())
            }
            .padding()
            .sheet(isPresented: $isSheetPresented) {
                AddRemindersView()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            EditListView()
        }
    }
    
    struct RemindersView_Previews: PreviewProvider {
        static var previews: some View {
            RemindersView()
        }
    }
}
