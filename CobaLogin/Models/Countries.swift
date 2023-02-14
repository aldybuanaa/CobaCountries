//
//  Countries.swift
//  CobaLogin
//
//  Created by developer on 24/01/23.
//

import Foundation

struct Countries: Codable {
    var name: Name?
    var capital: [String]?
    var region: String
    var subregion: String?
    var languages: [String: String]?
    var population: Int
    var flags,coatOfArms: CoatOfArms
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(Name.self, forKey: .name)
        self.capital = try container.decodeIfPresent([String].self, forKey: .capital)
        self.region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        self.subregion = try container.decodeIfPresent(String.self, forKey: .subregion)
        self.languages = try container.decodeIfPresent([String : String].self, forKey: .languages)
        self.population = try container.decodeIfPresent(Int.self, forKey: .population) ?? 0
        self.flags = try container.decode(CoatOfArms.self, forKey: .flags)
        self.coatOfArms = try container.decode(CoatOfArms.self, forKey: .coatOfArms)
    }
}

// MARK: - CoatOfArms
struct CoatOfArms: Codable {
    let png: String?
    let svg: String?
}

// MARK: - Name
struct Name: Codable {
    let common: String
}



