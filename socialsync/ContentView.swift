//
//  ContentView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
            
        TabView{
            InvitationList()
                .tabItem {
                    Label("Invitations", systemImage: "tray.and.arrow.down.fill")
                }
            InvitationRow(invitation: events[0])
                .tabItem {
                    Label("My Events", systemImage: "tray.and.arrow.down.fill")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
