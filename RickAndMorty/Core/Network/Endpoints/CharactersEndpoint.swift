//
//  CharactersEndpoint.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

enum CharactersEndpoint: EndpointProtocol {
    case characters(page: Int? = nil, status: String? = nil)
    case character(id: Int)
    
    var baseURL: String {
        NetworkConfiguration.defaultNetworkConfiguration.baseURL
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/character"
        case .character(let id):
            return "/character/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .characters, .character:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(let page, let status):
            var items: [URLQueryItem] = []
            if let page = page {
                items.append(URLQueryItem(name: "page", value: String(page)))
            }
            if let status = status {
                items.append(URLQueryItem(name: "status", value: status))
            }
            return items.isEmpty ? nil : items
        case .character:
            return nil
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
