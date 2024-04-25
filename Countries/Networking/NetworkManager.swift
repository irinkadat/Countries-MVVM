//
//  NetworkManager.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(completion: @escaping ([Country]?, Error?) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                completion(countries, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
