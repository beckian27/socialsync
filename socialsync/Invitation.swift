//
//  event.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation
import SwiftUI

struct Invitation: Codable, Hashable {
    let event_name: String
    let avail_time: [Date]
    let host_name: String //whoever sent out the invitation
    let group_id: Int //unique value
    let image_name: String
    var image: Image {
        Image(image_name)
    }
}


