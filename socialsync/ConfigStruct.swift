//
//  ConfigStruct.swift
//  socialsync
//
//  Created by Ian Beck on 10/25/23.
//

import Foundation

struct ConfigStruct: Codable, Hashable {
    var logged_in: Bool
    var username: String
}
