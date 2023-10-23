//
//  EventView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI

struct InvitationRow: View {
    var invitation: Invitation
    
    var body: some View {
        HStack {
            invitation.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(invitation.host_name)
            
            Spacer()
        }
        
    }
}

struct InvitationRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InvitationRow(invitation: invitations[0])
                .previewLayout(.fixed(width: 300, height: 70))
            InvitationRow(invitation: invitations[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
