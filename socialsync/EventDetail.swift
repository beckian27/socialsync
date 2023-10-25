//
//  EventDetail.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import SwiftUI

struct EventDetail: View {
    var events: MyEvent
    
    var body: some View {
        ScrollView {
            CircleImage(image: events.image)
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
                
                Divider()
                Text(events.host_name + " invited you to the " + events.event_name)
                
                Spacer()
                Spacer()
                Spacer()
                    .padding()
                //                Button(action: {
                //                    print("selecting time")
                //                    // jump to a different page
                //                }) {
                //                    Text("Accept")
                //                        .font(.system(size: 14))
                //                        .frame(minWidth: 0, maxWidth: .infinity)
                //                        .padding()
                //                        .foregroundColor(.white)
                //                        .background(Color(red: 88 / 255, green: 224 / 255, blue: 133 / 255))
                //                        .cornerRadius(5)
                //                        .padding(.horizontal, 20)
                //                }
                //            }
                //            Spacer()
                //            Spacer()
                //            Button(action: {
                //                print("Maybe Next time")
                //                // exit current scope and delete the invitation.
                //            }) {
                //                Text("Reject")
                //                    .font(.system(size: 14))
                //                    .frame(minWidth: 0, maxWidth: .infinity)
                //                    .padding()
                //                    .foregroundColor(.white)
                //                    .background(Color(red: 224 / 255, green: 0 / 255, blue: 0 / 255))
                //                    .cornerRadius(5)
                //                    .padding(.horizontal, 20)
                //            }
                //        }
                    
            }
            .padding()
            .navigationTitle(events.host_name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventDetail(events: events[1])
}
