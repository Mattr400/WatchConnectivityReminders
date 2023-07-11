//
//  IOSHomeView.swift
//  iOS Version of Storybook Project
//
//  Created by Matthew Regalado on 6/9/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            //Geometry Reader For Features Frame
            
            GeometryReader{reader in
                
                let rect = reader.frame(in: .global)
                
                VStack(spacing: 15) {
                    
                    HStack(spacing: 25) {
                        //Buttons
                        
                        NavigationLink(destination: RemindersView(), label: {
                            NavButton(image: "list.triangle", title: "Reminders", rect: rect, color: Color.red)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        NavButton(image: "music.note", title: "Music", rect: rect, color: Color.blue)
                    }
                    .padding(20)
                    .frame(width: rect.width, alignment: .center)
                }
            }
            
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

