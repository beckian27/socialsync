//
//  event.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation
import SwiftUI

struct Invitation: Codable, Hashable {
    let name: String
//    var start: Date
//    var end: Date
    let group: String
    
    let imageName: String

    var image: Image {
        Image(imageName)
    }
}


