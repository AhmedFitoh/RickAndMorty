//
//  CharactersNetworkService.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

protocol CharactersNetworkServiceProtocol {
    func fetchCharacters(page: Int?,
                         status: String?) async throws -> PaginatedResponseModel<CharacterModel>
    func fetchCharacter(id: Int) async throws -> CharacterModel
}

final class CharactersNetworkService: CharactersNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCharacters(page: Int? = nil,
                         status: String? = nil) async throws -> PaginatedResponseModel<CharacterModel> {
        return try await networkService.request(endpoint: CharactersEndpoint.characters(page: page,
                                                                                        status: status))
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterModel {
        return try await networkService.request(endpoint: CharactersEndpoint.character(id: id))
    }
}
