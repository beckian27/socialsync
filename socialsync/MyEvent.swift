//
//  MyEvent.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import Foundation
import SwiftUI

struct MyEvent: Codable, Hashable {
    let event_id: Int //unique value
    let event_name: String
    let time: String
    let host_name: String //whoever sent out the invitation
    let group_id: Int
    let image_name: String
    let confirmed: Int
    let voting_required: Int
    
    var is_confirmed: Bool {
        return confirmed == 1
    }
    var needs_voting: Bool {
        return voting_required == 1
    }
    var image: Image {
        Image(image_name)
    }
}

