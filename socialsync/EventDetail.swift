//
//  EventDetail.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import SwiftUI

struct EventDetail: View {
    var event: MyEvent
    
    var body: some View {
        ScrollView {
            CircleImage(image: event.image)
                .offset(y: 0)
                .padding(.bottom, -5)
            
            VStack (alignment: .leading) {
                
                Text(event.event_name)
                    .font(.title)
                Text("Hosted by " + event.host_name)
                    .font(.subheadline)
                
                Divider()
                Spacer()
                Spacer()
                
                Text(event.times.start.formatted(date:.omitted, time:.shortened) + " - " + event.times.end.formatted(date:.omitted, time:.shortened))
                Text(event.times.start.formatted(date:.complete, time: .omitted))
                
                Divider()
                Spacer()
                Spacer()
                
                Text("Attending:")
                ForEach(event.attendeez, id: \.self) { user in
                    Text(user)
                }
           
            }
            .padding()
            .navigationTitle(event.host_name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventDetail(event: events[1])
}
