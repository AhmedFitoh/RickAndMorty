//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: EndpointProtocol) async throws -> T
    func request<T: Decodable>(url: URL) async throws -> T
}

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
}

final class NetworkService: NetworkServiceProtocol {
    private let configuration: NetworkConfiguration
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder
    
    init(
        configuration: NetworkConfiguration = .defaultNetworkConfiguration,
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.configuration = configuration
        self.session = session
        self.decoder = decoder
        
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T: Decodable>(endpoint: EndpointProtocol) async throws -> T {
        guard let url = makeURL(for: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add endpoint-specific headers
        endpoint.headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return try await performRequest(request)
    }
    
    func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return try await performRequest(request)
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            throw NetworkError.httpError(httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError("Server error with status code: \(httpResponse.statusCode)")
        default:
            throw NetworkError.unexpectedError(NSError(domain: "Unknown", code: httpResponse.statusCode))
        }
    }
    
    private func makeURL(for endpoint: EndpointProtocol) -> URL? {
        var urlComponents = URLComponents(string: endpoint.baseURL)
        urlComponents?.path += endpoint.path
        urlComponents?.queryItems = endpoint.queryItems
        return urlComponents?.url
    }
}
