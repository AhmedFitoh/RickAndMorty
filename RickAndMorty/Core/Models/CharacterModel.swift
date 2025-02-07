//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

struct CharacterModel: Codable {
    let id: Int
    let name: String?
    let status: CharacterStatus?
    let species: String?
    let gender: Gender?
    let image: String?
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
        case unknown = "unknown"
    }
}

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
