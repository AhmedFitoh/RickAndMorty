//
//  NetworkServiceTests.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import XCTest
@testable import RickAndMorty

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var mockSession: MockURLSessionProtocol!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSessionProtocol()
        sut = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testSuccessfulRequest() async throws {
        // Given
        let mockData = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human"
        }
        """.data(using: .utf8)!
        
        mockSession.mockData = mockData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let character: CharacterModel = try await sut.request(
            endpoint: CharactersEndpoint.character(id: 1)
        )
        
        // Then
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, .alive)
    }
    
    func testNetworkError() async {
        // Given
        mockSession.mockError = NetworkError.invalidResponse
        
        // When/Then
        do {
            let _: CharacterModel = try await sut.request(
                endpoint: CharactersEndpoint.character(id: 1)
            )
        } catch {
            print(error)
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    func testDecodingError() async {
        // Given
        let invalidJSON = "invalid json".data(using: .utf8)!
        mockSession.mockData = invalidJSON
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        do {
            let _: CharacterModel = try await sut.request(
                endpoint: CharactersEndpoint.character(id: 1)
            )
            XCTFail("Expected error to be thrown")
        } catch {
            guard case NetworkError.decodingError = error else {
                XCTFail("Expected decodingError, got \(error)")
                return
            }
        }
    }
}
