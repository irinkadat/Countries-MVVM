import Foundation
import UIKit

class DetailsViewModel {
    
    var country: Country?
    var flagImage: UIImage?
    var flagDetails: String?
    var timezone: String?
    var spelling: String?
    var capital: String?
    var borders: String?
    var population: String?
    var region: String?
    
    var onDataUpdate: (() -> Void)?
    
    func fetchCountryDetails() {
        guard let country = country else { return }
        
        if let flagURLString = country.flags["png"], let flagURL = URL(string: flagURLString) {
            ImageDownloader.shared.downloadImage(from: flagURL) { [weak self] image in
                self?.flagImage = image
                self?.onDataUpdate?()
            }
        }
        flagDetails = country.flags["alt"]
        timezone = country.timezones.first
        spelling = country.altSpellings.last
        capital = country.capital?.joined(separator: ", ")
        borders = country.borders?.joined(separator: ", ")
        population = String(country.population)
        region = country.region
        
        onDataUpdate?()
    }
}



