//
//  ModelData.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation

var events: [Invitation] = load("josh.json")
var servername = "http://ec2-3-147-60-46.us-east-2.compute.amazonaws.com/api/v1/"


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
