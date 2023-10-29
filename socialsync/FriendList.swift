//
//  FriendDetail.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/29/23.
//

import SwiftUI

struct FriendList: View {
    var friend: [MyFriend]
    var body: some View {
        NavigationView {
            List(friends, id: \.self) { friend in
                NavigationLink(destination: Text("Detail view for \(friend.friends)")) {
                    Text(friend.friends)
                }
            }
            .navigationBarTitle("Friend List")
            .navigationBarItems(trailing:
                Button(action: {
                    //showingAddFriend.toggle()
                }) {
                    Image(systemName: "plus.circle")
                }
            )
        }
    }
}

#Preview {
    
    FriendList(friend: friends)
}
