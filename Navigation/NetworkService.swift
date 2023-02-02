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
    case url3 = "https://swapi.dev/api/planets/1"
    
    static func random() -> AppConfiguration {
        return allCases.randomElement()!
    }
}

struct Planet: Decodable {
    let name: String
    let rotationPeriod: String
    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
    }
}

struct Resident: Decodable {
    let name: String
}

struct PlanetWirhResidents: Decodable {
    let name: String
    let rotationPeriod: String
    let residents: [String]
    enum CodingKeys: String, CodingKey {
        case name
        case residents
        case rotationPeriod = "rotation_period"
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

                if let httpResponse = response as? HTTPURLResponse {
                    print("status code: \(httpResponse.statusCode)")
                    print("all header fields: \(httpResponse.allHeaderFields)")
                }

                if error != nil {
                    print("error: \(error.debugDescription)") // при выключенном wifi Code=-1009
                }
            }
            task.resume()
        }
     }
    
    static func getTitle(for configaration: AppConfiguration, completion: @escaping (_ title: String) -> ()) {
        
        if let url = URL(string: configaration.rawValue) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unwrappedData = data {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        if let dict = dictionary as? [String: Any], let title = dict["title"] as? String  {
                            completion(title)
                        }
                    }
                    catch let error {
                        print("\(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    static func getOrbitalPeriod(for configaration: AppConfiguration, completion: @escaping (_ title: String) -> ()) {
        
        if let url = URL(string: configaration.rawValue) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unwrappedData = data {
                    
                    do {
                        let planet = try JSONDecoder().decode(Planet.self, from: unwrappedData)
                        completion(planet.rotationPeriod)
                    }
                    catch let error {
                        print("\(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    static func getResidents(for configaration: AppConfiguration, completion: @escaping (_ title: String) -> ()) {
        
        if let url = URL(string: configaration.rawValue) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unwrappedData = data {
                    
                    do {
                        let planet = try JSONDecoder().decode(PlanetWirhResidents.self, from: unwrappedData)
                        
                        for residentURL in planet.residents {
                            
                            let taskResident = URLSession.shared.dataTask(with: URL(string: residentURL)!) { dataResident, responseResident, errorResident in
                                do {
                                    if let unwrappedDataResident = dataResident {
                                        let resident = try JSONDecoder().decode(Resident.self, from: unwrappedDataResident)
                                        completion(resident.name)
                                    }
                                }
                                catch let errorResident {
                                    print("\(errorResident)")
                                }
                            }
                            taskResident.resume()
                        }
                    }
                    catch let error {
                        print("\(error)")
                    }
                }
            }
            task.resume()
        }
    }
}


