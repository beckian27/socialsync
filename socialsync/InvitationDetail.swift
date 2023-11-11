//
//  EventDetail.swift
//  socialsync
//
//  Created by Ian Beck on 9/24/23.
//

import SwiftUI

struct InvitationDetail: View {
    var invitation: Invitation
    @State var accepting = false
    @Environment(\.dismiss) private var dismiss
    @State var info: [group] = [group(group_id: 1, group_name: "theboys", members: ["joe"])]
    var body: some View {
        
        NavigationStack {
            
            CircleImage(image: invitation.image)
                .offset(y: 0)
                .padding(.bottom, -5)
            
            VStack (alignment: .leading) {
                Text("You're invited to " + invitation.event_name)
                    .font(.title)
                
                HStack {
                    Text("Potential timeslots:")
                        .font(.subheadline)
                    Spacer()
                    Text("goodbye")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                ForEach(invitation.times, id: \.self) { time in
                    Text(time.start.formatted() + "-" + time.end.formatted(date:.omitted, time:.shortened))
                }
                Text("Invited:")
                ForEach(info[0].members, id:\.self) { member in
                    Text(member)
                }
                
                
                
                Divider()
                    .navigationDestination(isPresented: $accepting){
                        Gear(invite_id: invitation.invite_id)
                    }
                
                
                Spacer()
                Spacer()
                Spacer()
                    .padding()
                Button(action: {
                    possible_time = invitation.times
                    //let _:[String] = apipost(endpoint: "/test/1/", parameters: [:])
                    accepting.toggle()
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
                
            }.padding()
            Spacer()
            Spacer()
            Button(action: {
                print("Maybe Next time")
                let _:[String] = apipost(endpoint: "test2/", parameters: [:])
                dismiss()
                // exit current scope and delete the invitation.
            }) {
                Text("Reject")
                    .font(.system(size: 14))
                    .frame(minWidth: 10, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 224 / 255, green: 0 / 255, blue: 0 / 255))
                    .cornerRadius(5)
                    .padding(.horizontal, 20)
            }
            .padding()
            .task {
                do {
                    info = try await performAPICall(endpoint: "/groups/")
                }
                catch {}
            }
            
            .navigationTitle(invitation.host_name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    InvitationDetail(invitation: invitations[1])
}
