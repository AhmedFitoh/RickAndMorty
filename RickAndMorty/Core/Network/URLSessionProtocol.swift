//
//  URLSessionProtocol.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
extension URLSession: URLSessionProtocol { }
