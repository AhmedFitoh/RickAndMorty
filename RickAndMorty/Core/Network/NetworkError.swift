//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case serverError(String)
    case noData
    case unauthorized
    case unexpectedError(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from the server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Unauthorized access"
        case .unexpectedError(let error):
            return "Unexpected error: \(error.localizedDescription)"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.noData, .noData),
             (.unauthorized, .unauthorized):
            return true
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
        case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.decodingError, .decodingError),
             (.unexpectedError, .unexpectedError):
            // Since Error doesn't conform to Equatable, we'll consider these equal if they're the same case
            return true
        default:
            return false
        }
    }
}

