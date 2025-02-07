//
//  NetworkConfiguration.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

struct NetworkConfiguration {
    let baseURL: String
    
    static let defaultNetworkConfiguration = NetworkConfiguration(
        baseURL: "https://rickandmortyapi.com/api"
    )
}
