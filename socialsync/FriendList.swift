//
//  FriendDetail.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/29/23.
//

import SwiftUI

struct MyFriend: Codable, Hashable {
    let fullname: String
}


struct FriendList: View {
    var friend: [MyFriend]
    @State private var showingAddFriend = false
    var body: some View {
        NavigationStack {
            List(friend, id: \.fullname) { friend in
                NavigationLink(destination: Text("Detail view for \(friend.fullname)")) {
                    Text(friend.fullname)
                }
            }
            .navigationBarTitle("Friend List")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddFriend.toggle()
                }) {
                    Image(systemName: "plus.circle")
                }
            )
            .sheet(isPresented: $showingAddFriend) {
                        AddFriend(isPresented: $showingAddFriend)
            }
        }
        
    }
}


struct AddFriend: View {
    @Binding var isPresented: Bool
    @State private var username: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Friend's Username")) {
                    TextField("Username: ", text: $username)
                }
            }
            .navigationBarTitle("Add Friend")
            .navigationBarItems(
                leading: Button("Cancel") {
                    //return to previous page
                    isPresented = false
                },
                trailing: Button("Add") {
                    apipost(endpoint: "add_friend/" + Config.username + "/", parameters: ["friendname": username])
                    isPresented = false
                    
                }
            )
        }
    }
}

#Preview {
    FriendList(friend: friends)
}
