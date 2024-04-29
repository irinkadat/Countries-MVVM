import Foundation

class DetailsViewModel {
    
    // MARK: - Properties
    
    var country: Country?
    var flagDetails: String?
    var timezone: String?
    var spelling: String?
    var capital: String?
    var borders: String?
    var population: String?
    var region: String?
    
    var flagImg: URL? {
        URL(string: country?.flags["png"] ?? "")
    }
    var onDataUpdate: (() -> Void)?
    
    init(country: Country) {
        self.country = country
    }
    
    // MARK: - Fetch country details
    
    func fetchCountryDetails() {
        guard let country = country else { return }
        
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



