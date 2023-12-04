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
            
            
            VStack (alignment: .leading) {
                Spacer()
                HStack {
                    Spacer()
                    CircleImage(image: event.image)
                        .offset(y: 0)
                    .padding(.bottom, -5)
                    Spacer()
                }
                
                Text("  " + event.event_name)
                    .font(.title).bold()
                Text("   Hosted by " + event.host_name)
                    .font(.subheadline).bold()
                
                Divider()
                
                Text("   " + event.times.start.formatted(date:.omitted, time:.shortened) + " - " + event.times.end.formatted(date:.omitted, time:.shortened))
                Text("   " + event.times.start.formatted(date:.complete, time: .omitted))
                
                Divider()
                
                Text("   Attending:").bold()
                ForEach(event.attendeez, id: \.self) { user in
                    Text("   " + user)
                }
                Spacer()
                Spacer()
                Spacer()
           
            }.background(Color.back)
            .navigationBarTitleDisplayMode(.inline)
        }
    
}

#Preview {
    EventDetail(event: events[1])
}
