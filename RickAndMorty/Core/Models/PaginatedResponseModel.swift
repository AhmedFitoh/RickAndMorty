//
//  PaginatedResponse.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

struct PaginatedResponseModel<T: Codable>: Codable {
    let info: PageInfoModel
    let results: [T]
}

struct PageInfoModel: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
