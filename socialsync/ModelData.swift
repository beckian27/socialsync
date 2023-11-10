//
//  ModelData.swift
//  socialsync
//
//  Created by Ian Beck on 9/23/23.
//

//https://github.com/WangLiquan/EWCircleView.git
//https://github.com/wert1991216/HJCycleView.git

import Foundation
var invitations: [Invitation] = load("josh.json")//[]
var events: [MyEvent] = load("Allen.json")
var friends: [MyFriend] = [MyFriend(fullname:"Alice"), MyFriend(fullname:"Bob"), MyFriend(fullname:"Charlie")]//temp test
//var servername = "http://172.20.10.5:8000/api/v1/"
//var servername = "http://192.168.1.135:8000/api/v1/"
var Config: ConfigStruct = load("config.json")
var servername = "http://ec2-13-58-26-236.us-east-2.compute.amazonaws.com/api/v1/"

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
    let url = URL(string: servername + endpoint + Config.username + "/")!
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
func apipost<T: Codable>(endpoint: String, parameters: [String: String]) -> [T] {
    var components = URLComponents(string: servername + endpoint)!
    var items: [URLQueryItem] = []
    for item in parameters {
        items.append(URLQueryItem(name:item.key, value: item.value))
    }
    components.queryItems = items
    //let url = URL(string: servername + endpoint + Config.username + "/")!
    var request = URLRequest(url: components.url!)
    let bodyData = try? JSONSerialization.data(
        withJSONObject: parameters,
        options: []
    )

    // Change the URLRequest to a POST request
    request.httpMethod = "POST"
    request.httpBody = bodyData
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    
    let session = URLSession.shared
    var result: [T] = []
    let task = session.dataTask(with: request) { (data, response, error) in

        if let error = error {
            // Handle HTTP request error
        } else if let data = data {
            do {
                let wrapper = try JSONDecoder().decode(Wrapper<T>.self, from: data)
                result = wrapper.items
            }
            catch {
                print(data as NSData, error)
            }
        } else {
            // Handle unexpected error
        }
    }
    task.resume()
    
    return result
    
}

func postRequest(endpoint: String, parameters: [String: Any]) -> Void {
    
    // create the url with URL
    let url = URL(string: servername + endpoint + Config.username + "/")!
    
    // create the session object
    let session = URLSession.shared
    
    // now create the URLRequest object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "POST" //set http method as POST
    
    // add headers for the request
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        // convert parameters to Data and assign dictionary to httpBody of request
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        return
    }
    let task = session.dataTask(with: request) { data, response, error in
        
        if let error = error {
            print("Post Request Error: \(error.localizedDescription)")
            return
        }
    }
        
        // perform the task
        task.resume()
}

