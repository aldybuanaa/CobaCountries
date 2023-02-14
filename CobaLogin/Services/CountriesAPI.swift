//
//  CountriesAPI.swift
//  CobaLogin
//
//  Created by developer on 24/01/23.
//

import Foundation
import Alamofire

class CountriesAPI {
    static let shared = CountriesAPI()
    private init() { }
    
    private lazy var sessionManager: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30
        return Session(configuration: config)
    }()
    
    func fetchCountries(completion: @escaping (Result<[Countries], Error>) -> Void) {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        sessionManager.request(url, method: .get)
            .validate()
            .responseDecodable(of: [Countries].self) { (response) in
                switch response.result {
                case .success(let countries):
                    completion(.success(countries))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
//    func fetchData(completion: @escaping ([Countries]) -> () ) {
//        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {return}
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        
//        URLSession(configuration: config).dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    completion([])
//                }
//                return
//            }
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion([])
//                }
//                return
//            }
//            
//            do {
//                let jsonData = try JSONDecoder().decode([Countries].self, from: data)
//                DispatchQueue.main.async {
//                    completion(jsonData)
//                }
//            }
//            catch {
//                print("Errr:::", error)
//                DispatchQueue.main.async {
//                    completion([])
//                }
//            }
//            
//        }.resume()
//    }
//    
}
