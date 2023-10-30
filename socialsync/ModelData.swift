//
//  ModelData.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

import Foundation

var invitations: [Invitation] = load("josh.json")//[]
var events: [MyEvent] = load("Allen.json")
var friends: [MyFriend] = [MyFriend(fullname:"Alice"), MyFriend(fullname:"Bob"), MyFriend(fullname:"Charlie")]//temp test
var servername = "http://192.168.1.135:8000/api/v1/"
var Config: ConfigStruct = load("config.json")
//var servername = "http://ec2-13-58-26-236.us-east-2.compute.amazonaws.com/api/v1/"

struct Wrapper<T: Codable>: Codable {
    let items: [T]
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

func performAPICall<T: Codable>(endpoint: String) async throws -> [T] {
    let url = URL(string: servername + endpoint)!
    let (data, _) = try await URLSession.shared.data(from: url)
    do {
        let wrapper = try JSONDecoder().decode(Wrapper<T>.self, from: data)
        return wrapper.items
    }
    catch {
        print(data as NSData, error)
    }
    return []
        
}
