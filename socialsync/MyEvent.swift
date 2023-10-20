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
    let name: String
//    var start: Date
//    var end: Date
    let group: String
    
    let imageName: String

    var image: Image {
        Image(imageName)
    }
}

