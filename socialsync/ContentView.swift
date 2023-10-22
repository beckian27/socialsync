//
//  ContentView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI

struct ContentView: View {
    @State var invites = events
    var body: some View {
            
        TabView{
            VStack {
                InvitationList(invites: invites)
                    .tabItem {
                        Label("Invitations", systemImage: "tray.and.arrow.down.fill")
                }
            }
            .task{
                do {
                        invites = try await performAPICall()
                        print(events, "events")
                    }
                catch {print("aghh")}
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
        print("hello")
        do {
            let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
            print(wrapper)
            return wrapper.items
        }
        catch {
            print(data)
        }
        return []
            
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
