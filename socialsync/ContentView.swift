
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
    @State var eventz = events
    @State var friendlist = friends
    
    var badgeValue: String? {
            if confirm_required {
                return "!"
            } else {
                return nil

            }
        }
    
    var body: some View {
            TabView {
                NavigationStack{
                    InvitationList(invites: invites)
                        
                        .task{
                            do {
                                invites = try await performAPICall(endpoint: "/invitations/")
                            }catch {
                                print("aghh")
                            }
                        }
                }
                .badge(num_pending)
                .tabItem{
                    Label("Invitations", systemImage: "envelope.circle.fill")
                }
                NavigationStack {
                    EventList(events: eventz)
                        
                        .task{
                            do {
                                eventz = try await performAPICall(endpoint: "/events/")
                            }catch {
                                print("aghh")
                            }
                    }
                        
                }
                .badge(badgeValue)
                .tabItem{
                    Label("My Events", systemImage: "personalhotspot")
                }
                
                NavigationStack {
                    FriendList(friend: friendlist)
                        
                        .task{
                            do {
                                friendlist = Array(Set(try await performAPICall(endpoint: "/friends/")))
                            }catch {
                                print("aghh")
                            }
                    }
                    
                }
                .badge(pending_friends)
                .tabItem{
                    Label("Friends", systemImage: "person.crop.circle.fill")
                }
            }
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
