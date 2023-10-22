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
            VStack {
                InvitationList()
                    .tabItem {
                        Label("Invitations", systemImage: "tray.and.arrow.down.fill")
                }
            }
            .task{
                do {
                        events = try await performAPICall()
                    } catch {
                        return
                    }
            }
            InvitationRow(invitation: events[0])
                .tabItem {
                    Label("My Events", systemImage: "tray.and.arrow.down.fill")
                }
        }
        
    }
    
    func performAPICall() async throws -> [Invitation] {
        let url = URL(string: servername)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let wrapper = try JSONDecoder().decode([Invitation].self, from: data)
            return wrapper
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
