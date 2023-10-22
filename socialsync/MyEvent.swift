//
//  MyEvent.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import Foundation
import SwiftUI

struct MyEvent: Codable, Hashable {
    let event_name: String
    let start: Date
    let end: Date
    let host_name: String //whoever sent out the invitation
    let group_id: Int //unique value
    let image_name: String
    let confirmed: Bool
    let voting_required: Bool
    var image: Image {
        Image(image_name)
    }
}

