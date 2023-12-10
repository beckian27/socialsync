//
//  timepair.swift
//  socialsync
//
//  Created by Ian Beck on 10/30/23.
//

import Foundation

struct BestTime: Codable {
    let time_in: String
    let users_in: String
    
    var time: DateInterval {
        return decode_timestring(timestring: time_in)
    }
    
    var users: [String] {
        let usrs: [String] = []
        return usrs
    }
}

func decode_timestring(timestring: String) -> DateInterval {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy HH:mm"
    let splitstring = timestring.split(separator: "~")
    let a = formatter.date(from: String(splitstring[0]))
    let b = formatter.date(from: String(splitstring[1]))
    return DateInterval(start:a!, end:b!)
}

func decode_invite_string(timestring: String) -> [DateInterval] {
    let splitstring = timestring.split(separator: "|")
    var times: [DateInterval] = []
    for time in splitstring {
        times.append(decode_timestring(timestring: String(time)))
    }
    return times
}

func encode_response(avail_times: [DateInterval]) -> String {
    var timestring = ""
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy HH:mm"
    for time in avail_times {
        if !timestring.isEmpty {
            timestring += "|"
        }
        let a = formatter.string(from: time.start)
        let b = formatter.string(from: time.end)
        timestring += (a + "~" + b)
    }
    return timestring
}

//func display_interval(time: DateInterval) -> String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MM-dd-yyyy HH:mm"
//}
