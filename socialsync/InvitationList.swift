//
//  EventList.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI

struct InvitationList: View {
    var body: some View {
        
        NavigationStack {
            List(events, id: \.name) {
                Invitation in
                NavigationLink {
                    InvitationDetail(invitation: Invitation)
                } label:  {
                    InvitationRow(invitation: Invitation)
                }
            }
            .navigationTitle("invitations")
        }
    }
}

#Preview {
    InvitationList()
}
