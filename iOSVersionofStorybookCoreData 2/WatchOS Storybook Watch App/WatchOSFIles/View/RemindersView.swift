//
//  RemindersView.swift
//  WatchOS Storybook Watch App
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI

struct RemindersView: View {
    var body: some View {
        
        NavigationStack {
            //Geometry Reader For Options Frame
            
            GeometryReader{reader in
                
                let rect = reader.frame(in: .global)
                
                VStack(spacing: 15) {
                    
                    HStack {
                        //Buttons
                        NavigationLink(destination: AddRemindersView()) {
                            NavButton(image: "plus", title: "Add Reminder", rect: rect, color: Color.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
         
                        HStack {
                            //Buttons
                            NavigationLink(destination: EditListView()) {
                                NavButton(image: "doc.plaintext", title: "View/Edit", rect: rect, color: Color.gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
            }
        }
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
