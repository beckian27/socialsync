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
            Text(invitation.name)
            
            Spacer()
        }
        
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InvitationRow(invitation: events[0])
                .previewLayout(.fixed(width: 300, height: 70))
            InvitationRow(invitation: events[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
