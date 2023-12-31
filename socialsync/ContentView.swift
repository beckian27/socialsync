
//  ContentView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI

struct ContentView: View {
    @State var invites = invitations
    @State var num_pending = invitations.count
    @State var confirm_required = false
    @State var pending_friends = 0
    @State var eventz = events
    @State var friendlist = friends
    @State var fijsd = !Config.logged_in

    
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
                        .navigationDestination(isPresented: $fijsd) {
                            LoginView()
                        }
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.white, for: .tabBar)
                
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
                   // DatePicker()
                    FriendList(friend: friendlist)
                        
                        .task{
                            do {
                                friendlist = try await performAPICall(endpoint: "/friends/")
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
            
            
            .task {
                fijsd = !Config.logged_in
                print("hi", fijsd)
            }
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
