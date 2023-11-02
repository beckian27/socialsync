//
//  EventDetail.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI

struct InvitationDetail: View {
    var invitation: Invitation
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView {
            CircleImage(image: invitation.image)
                .offset(y: 0)
                .padding(.bottom, -5)
            
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
                ForEach(invitation.times, id: \.self) { time in
                    Text(time.start.formatted() + "-" + time.end.formatted())
                }
                
                Divider()
                
                
                
                Spacer()
                Spacer()
                Spacer()
                .padding()
                Button(action: {
                    print("selecting time")
                    // jump to a different page
                }) {
                    Text("Accept")
                        .font(.system(size: 14))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 88 / 255, green: 224 / 255, blue: 133 / 255))
                        .cornerRadius(5)
                        .padding(.horizontal, 20)
                }
            }
            Spacer()
            Spacer()
            Button(action: {
                print("Maybe Next time")
                //pass to api to delete the invite
                dismiss()
                // exit current scope and delete the invitation.
            }) {
                Text("Reject")
                    .font(.system(size: 14))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 224 / 255, green: 0 / 255, blue: 0 / 255))
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
        .navigationTitle(invitation.host_name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    InvitationDetail(invitation: invitations[1])
}
