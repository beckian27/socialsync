//
//  ModelData.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation

var invitations: [Invitation] = load("josh.json")
var events: [MyEvents] = load("Allen.json")
var servername = "http://192.168.1.135:8000/api/v1/posts/"

struct Wrapper: Codable {
    let items: [Invitation]
}

struct Config: Codable {
    var logged_in: Bool = false
    var user: String
    
}


func load<T: Decodable>(_ filename: String) -> T {	
    let data: Data


    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
    
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
