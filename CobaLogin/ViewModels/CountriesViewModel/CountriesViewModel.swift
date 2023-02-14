//
//  CountriesViewModel.swift
//  CobaLogin
//
//  Created by developer on 27/01/23.
//

import Foundation

class CountriesViewModel {
    var countries: [Countries] = []
    
    func fetch(completion: @escaping (Error?) -> Void) {
        CountriesAPI.shared.fetchCountries { [weak self] (result) in
            switch result {
            case .success(let countries):
                self?.countries = countries
                dump(self?.countries)
                completion(nil)
                
            case.failure(let error):
                completion(error)
            }
        }
    }
    
//    func fetch(completion: @escaping () -> ()) {
//        CountriesAPI.shared.fetchData { countries in
//            self.countries = countries
//            dump(self.countries)
//            completion()
//        }
//    }
    
    func numberOrRows() -> Int {
        return self.countries.count
    }
    
    func countryName(at index: Int) -> String? {
        return self.countries[index].name?.common
    }
    
    func countryFlag(at index: Int) -> String? {
        return self.countries[index].flags.png!
    }
}
