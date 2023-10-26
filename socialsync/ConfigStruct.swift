//
//  ConfigStruct.swift
//  socialsync
//
//  Created by Ian Beck on 10/25/23.
//

import Foundation

struct ConfigStruct: Codable, Hashable {
    let logged_in: Bool
    let username: String
}
