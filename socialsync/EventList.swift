//
//  EventList.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/22/23.
//

import SwiftUI

struct EventList: View {
    var events: [MyEvent]
    var body: some View {
        
        NavigationStack {
            List(events, id: \.username) {
                event in
                NavigationLink {
                    //EventDetail(Event: event) //TBD EventDetail
                } label:  {
                    //EventRow(Event: event) //TBD EventRow
                }
            }
            .navigationTitle("My Events")
        }
    }
}

#Preview {
    InvitationList(invites: events)
}
