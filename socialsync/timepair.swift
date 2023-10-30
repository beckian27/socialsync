//
//  timepair.swift
//  socialsync
//
//  Created by Ian Beck on 10/30/23.
//

import Foundation

func decode_timestring(timestring: String) -> DateInterval {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy HH:mm"
    let splitstring = timestring.split(separator: "|")
    let a = formatter.date(from: String(splitstring[0]))
    let b = formatter.date(from: String(splitstring[1]))
    return DateInterval(start:a!, end:b!)
}

func decode_invite_string
