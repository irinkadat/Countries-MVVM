//
//  Country.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import Foundation

struct Country: Codable {
    struct Name: Codable {
        let common: String
        let official: String
    }
    struct Maps: Codable {
        let googleMaps: String
        let openStreetMaps: String
    }
    let region: String
    let population: Int
    let altSpellings: [String]
    let borders: [String]?
    let timezones: [String]
    let capital: [String]?
    let name: Name
    let flags: [String: String]
    let maps: Maps
    
    enum CodingKeys: String, CodingKey {
        case region, population, altSpellings, borders, timezones, capital, name, flags, maps
    }
    
    enum NameCodingKeys: String, CodingKey {
        case common, official
    }
    
    enum MapsCodingKeys: String, CodingKey {
        case googleMaps, openStreetMaps
    }
}
