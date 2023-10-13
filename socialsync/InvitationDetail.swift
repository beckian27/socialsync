//
//  EventDetail.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI

struct InvitationDetail: View {
    var invitation: Invitation
    
    var body: some View {
        ScrollView {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage(image: invitation.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack (alignment: .leading) {
                Text("Hello, world!")
                    .font(.title)
                
                HStack {
                    Text("hello again")
                        .font(.subheadline)
                    Spacer()
                    Text("goodbye")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                
                Divider()
                Text(invitation.name + " says hello")
                
            }
            
            .padding()
        }
        .navigationTitle(invitation.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    InvitationDetail(invitation: events[1])
}
