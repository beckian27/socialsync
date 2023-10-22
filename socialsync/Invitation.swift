//
//  event.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation
import SwiftUI

struct Invitation: Codable, Hashable {
    let username: String
//    var start: Date
//    var end: Date
    let fullname: String
    
    let filename: String

    var image: Image {
        Image(fullname)
    }
}


