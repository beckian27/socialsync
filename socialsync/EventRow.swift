//
//  EventRow.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import Foundation
import SwiftUI

struct EventRow: View {
    var event: MyEvent

    var body: some View {
        HStack {
            event.image
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(event.event_name + " - " + event.host_name)
                Text(event.times.start.formatted())
            }
            .font(.custom("Verdana", size: 25))//.textCase(.uppercase)
            
            Spacer()
        }
        .foregroundColor(Color.white)
        .background(Color.bar)
        .cornerRadius(15)
        
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventRow(event: events[0])
                .previewLayout(.fixed(width: 300, height: 70))
            EventRow(event: events[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
