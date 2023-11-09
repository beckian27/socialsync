//
//  EventList.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import SwiftUI

struct EventList: View {
    var events: [MyEvent]
    @State var ye = false
    var body: some View {
        
        NavigationStack {
            List(events, id: \.event_id) {
                Event in
                NavigationLink {
                    EventDetail(event: Event)
                } label:  {
                    EventRow(event: Event)
                }
            }
            .navigationTitle("Future Events")
            .navigationBarItems(trailing:
                Button(action: {
                    ye.toggle()
                }) {
                    Image(systemName: "plus.circle")
                }
            )
            .navigationDestination(isPresented: $ye) {
                GroupList()
            }
        }
    }
}

#Preview {
    EventList(events: events)
}
