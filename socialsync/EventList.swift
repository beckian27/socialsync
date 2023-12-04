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
            VStack {
                ForEach(events, id: \.event_id) {
                    Event in
                    NavigationLink {
                        EventDetail(event: Event)
                    } label:  {
                        EventRow(event: Event)
                    }
                    .foregroundColor(.white)
                    .padding(10)
                }
                Spacer()
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
            .background(Color.back)
        }
    }
}

#Preview {
    EventList(events: events)
}
