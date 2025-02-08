//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import Foundation

final class CharacterListViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var selectedStatus: CharacterStatus?
    @Published private(set) var characters: [CharacterModel] = []

    weak var coordinator: CharacterListCoordinator?
    private let service: CharactersNetworkServiceProtocol
    private var currentPage = 1
    private var canLoadMore = true
    
    init(service: CharactersNetworkServiceProtocol) {
        self.service = service
    }
    
    @MainActor
    func loadCharacters(loadMore: Bool = false) async {
        if loadMore {
            guard canLoadMore else { return }
        } else {
            currentPage = 1
            canLoadMore = true
            characters = []
        }
        
        if case .loading = state { return }
        
        do {
            state = .loading
            let response = try await service.fetchCharacters(
                page: currentPage,
                status: selectedStatus?.rawValue
            )
            
            if loadMore {
                characters.append(contentsOf: response.results)
            } else {
                characters = response.results
            }
            
            state = .loaded
            canLoadMore = response.info.next != nil
            if canLoadMore {
                currentPage += 1
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func filterByStatus(_ status: CharacterStatus?) async {
        selectedStatus = status
        await loadCharacters()
    }
    
    func didSelectCharacter(_ character: CharacterModel) {
        coordinator?.showCharacterDetail(character)
    }
}
