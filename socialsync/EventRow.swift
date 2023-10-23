//
//  EventRow.swift
//  socialsync
//
//  Created by Yuansong Wang on 10/23/23.
//

import Foundation
import SwiftUI

struct EventRow: View {
    var Events: MyEvent

    var body: some View {
        HStack {
            Events.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(Events.host_name)
            
            Spacer()
        }
        
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventRow(MyEvents: events[0])
                .previewLayout(.fixed(width: 300, height: 70))
            EventRow(Events: events[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
    }
}
