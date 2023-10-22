//
//  MyEvent.swift
//  socialsync
//
//  Created by Ian Beck on 10/13/23.
//

import Foundation
import SwiftUI

struct MyEvent: Codable, Hashable {
    let confirmed: Bool
    let username: String
//    var start: Date
//    var end: Date
    let fullname: String
    
    let filename: String

    var image: Image {
        Image(filename)
    }
}

