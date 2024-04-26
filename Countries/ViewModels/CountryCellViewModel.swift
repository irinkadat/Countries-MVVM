//
//  CountryCellViewModel.swift
//  Countries
//
//  Created by Irinka Datoshvili on 25.04.24.
//
import Foundation

class CountryCellViewModel {
    let country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    var countryName: String {
        return country.name.common
    }
    
    var flagURL: String {
        return country.flags["png"]!
    }
    
    var population: String {
        return "\(country.population)"
    }
}

