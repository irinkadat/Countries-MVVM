//
//  CountryViewModel.swift
//  Countries
//
//  Created by Irinka Datoshvili on 24.04.24.
//

import Foundation

class CountriesViewModel {
    private let networkManager = NetworkManager.shared
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    
    var numberOfCountries: Int {
        return filteredCountries.count
    }
    
    func country(at index: Int) -> Country? {
        guard index >= 0 && index < filteredCountries.count else {
            return nil
        }
        return filteredCountries[index]
    }
    func fetchData(completion: @escaping (Error?) -> Void) {
        networkManager.fetchData { [weak self] countries, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            if let countries = countries {
                self.countries = countries
                self.filteredCountries = countries
                completion(nil)
            }
        }
    }
    
    func filterCountries(with searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { $0.name.common.lowercased().contains(searchText.lowercased()) }
        }
    }
}

