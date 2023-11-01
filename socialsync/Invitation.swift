//
//  event.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation
import SwiftUI

struct Invitation: Codable, Hashable {
    let invite_id: Int //unique value
    let event_name: String
    let avail_time: String
    let host_name: String //whoever sent out the invitation
    let group_id: Int
    let image_name: String
    var image: Image {
        Image(image_name)
    }
    var times: [DateInterval] {
        return decode_invite_string(timestring: avail_time)
    }
}


