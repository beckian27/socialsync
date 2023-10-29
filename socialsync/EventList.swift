//
//  EventList.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import SwiftUI

struct EventList: View {
    var events: [MyEvent]
    var body: some View {
        
        NavigationStack {
            List(events, id: \.group_id) {
                Event in
                NavigationLink {
                    EventDetail(events: Event)
                } label:  {
                    EventRow(Events: Event)
                }
            }
            .navigationTitle("Future Events")
            .navigationBarItems(trailing:
                Button(action: {
                    //showingCreateEvent.toggle()
                }) {
                    Image(systemName: "plus.circle")
                }
            )
        }
    }
}

#Preview {
    EventList(events: events)
}
