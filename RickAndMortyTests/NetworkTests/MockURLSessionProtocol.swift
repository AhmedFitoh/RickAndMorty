//
//  MockURLSession.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation
@testable import RickAndMorty

class MockURLSessionProtocol: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData,
              let response = mockResponse else {
            throw NetworkError.noData
        }
        
        return (data, response)
    }
}

