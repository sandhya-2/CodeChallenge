//
//  Acronym.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

struct Acronym: Decodable {
    let sf: String
    let lfs: [SpecificAcronym]
}

struct SpecificAcronym: Decodable {
    let lf: String
    let freq: Int
    let since: Int
    let variations: [Variation]
    
    enum CodingKeys: String, CodingKey {
        case variations = "vars"
        case lf, freq, since
    }
}

struct Variation: Decodable {
    let lf: String
    let freq: Int
    let since: Int
}
