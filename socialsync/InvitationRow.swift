//
//  EventView.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import SwiftUI
extension Color {
    static let bar = Color(red: 80/255, green: 108/255, blue: 250/255)
}
struct InvitationRow: View {
    var invitation: Invitation
    
    var body: some View {
        HStack {
            invitation.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(invitation.event_name + " - " + invitation.host_name).font(.custom("Verdana", size: 25))//.textCase(.uppercase)
            
            Spacer()
        }
        .foregroundColor(Color.white)
        .background(Color.bar)
        .cornerRadius(15)
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
