//
//  FriendDetail.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/29/23.
//

import SwiftUI

struct MyFriend: Codable, Hashable {
    let fullname: String
    let filename: String
}


struct FriendList: View {
    var friend: [MyFriend]
    @State private var showingAddFriend = false
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(friend, id: \.fullname) { friend in
                    NavigationLink(destination: Text("Detail view for \(friend.fullname)")) {
                        HStack {
                            Image(friend.filename).resizable()
                                .frame(width: 50, height: 50)
                            Text(friend.fullname).font(.custom("Verdana", size: 25))//.textCase(.uppercase)
                            Spacer()
                            
                        }
                        .foregroundColor(Color.white)
                        .background(Color.bar)
                        .cornerRadius(15)
                    }
                }
            }
            Spacer()
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
            .background(Color.back)
            
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
                    let _: [String] = apipost(endpoint: "add_friend/" + Config.username + "/", parameters: ["friendname": username])
                    isPresented = false
                    
                }
            )
        }
    }
}

#Preview {
    FriendList(friend: friends)
}
