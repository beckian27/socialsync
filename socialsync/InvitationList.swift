//
//  EventList.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI

struct InvitationList: View {
    var invites: [Invitation]
    var body: some View {
        
        NavigationStack {
            List(invites, id: \.group_id) {
                Invitation in
                NavigationLink {
                    InvitationDetail(invitation: Invitation)
                } label:  {
                    InvitationRow(invitation: Invitation)
                }
            }
            .navigationTitle("Pending Invitations")
        }
    }
}

#Preview {
    InvitationList(invites: invitations)
}
