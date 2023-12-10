//
//  EventList.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI
extension Color {
    static let back = Color(red: 198/255, green: 206/255, blue: 245/255)
}
struct InvitationList: View {
    
    var invites: [Invitation]
    var body: some View {
        NavigationStack {
            VStack {
                
                ForEach(invites, id: \.invite_id) {
                    Invitation in
                    NavigationLink {
                        InvitationDetail(invitation: Invitation)
                            .task{
                                possible_time = Invitation.times
                            }
                    } label:  {
                        InvitationRow(invitation: Invitation)
                        
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .navigationTitle("Pending Invitations")


                }
                .cornerRadius(15)
                Spacer()
            }
            .background(Color.back)
        }
        
    }
    
}

#Preview {
    InvitationList(invites: invitations)
}
