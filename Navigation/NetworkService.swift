//
//  NetworkService.swift
//  Navigation
//
//  Created by Наталья Босякова on 30.11.2022.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case url1 = "https://swapi.dev/api/films/1"
    case url2 = "https://swapi.dev/api/starships/9"
    case url3 = "https://swapi.dev/api/species/31"
    
    static func random() -> AppConfiguration {
        return allCases.randomElement()!
    }
}

struct NetworkService {
    static func request(for configaration: AppConfiguration) {
        if let url = URL(string: configaration.rawValue) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("session was started")
                if let unwrappedData = data {
                    let stringUTF8 = String(decoding: unwrappedData, as: UTF8.self)
                    print("data: \(stringUTF8)")
                }

                print("session was started 1")
                if let httpResponse = response as? HTTPURLResponse {
                    print("status code: \(httpResponse.statusCode)")
                    print("all header fields: \(httpResponse.allHeaderFields)")
                }

                print("session was started 2")
                if error != nil {
                    print("error: \(error.debugDescription)") // при выключенном wifi Code=-1009
                }
            }
            task.resume()
        }
     }
}


