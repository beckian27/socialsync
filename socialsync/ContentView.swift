
//  ContentView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI

struct ContentView: View {
    @State var invites = invitations
    @State var num_pending = 3
    @State var confirm_required = true
    @State var pending_friends = 99
    var badgeValue: String? {
            if confirm_required {
                return "!"
            } else {
                return nil

            }
        }
    var body: some View {
            
        //TabView{
//            VStack {
//                InvitationList(invites: invites)
//                    .tabItem {
//                        Label("Invitations", systemImage: "tray.and.arrow.down.fill")
//                }
//            }
//            .task{
//                do {
//                        invites = try await performAPICall()
//                        print(events, "events")
//                    }
//                catch {print("aghh")}
//            }
//            InvitationRow(invitation: events[0])
//                .tabItem {
//                    Label("My Events", systemImage: "tray.and.arrow.down.fill")
//                    
//                }
            TabView {
                InvitationList(invites: invites)
                    .badge(num_pending)
                    .tabItem{
                        Label("Invitations", systemImage: "envelope.circle.fill")
                    }
                    .task{
                        do {
                            invites = try await performAPICall()
                            print(invites, "invitations")
                        }catch {
                            print("aghh")
                        }
                    }
                EventList(events: events)//TBD: add an event list for future events and change this line form invitation list to event list.
                    .badge(badgeValue)
                    .tabItem{
                        Label("My Events", systemImage: "personalhotspot")
                    }
                InvitationList(invites: invites) //TBD: create a friend list view
                    .badge(pending_friends)
                    .tabItem{
                        Label("Friends", systemImage: "person.crop.circle.fill")
                    }
            }
        }
        
    }
    
    func performAPICall() async throws -> [Invitation] {
        let url = URL(string: servername)!
        let (data, _) = try await URLSession.shared.data(from: url)
        print("hello")
        do {
            let wrapper = try JSONDecoder().decode(Wrapper<Invitation>.self, from: data)
            print(wrapper)
            return wrapper.items
        }
        catch {
            print(data, error)
        }
        return []
            
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
