//
//  CharacterListCoordinator.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI

final class CharacterListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let service: CharactersNetworkServiceProtocol
    
    init(navigationController: UINavigationController,
         service: CharactersNetworkServiceProtocol = CharactersNetworkService()) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = CharacterListViewModel(service: service)
        viewModel.coordinator = self
        let viewController = CharacterListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
//    func showCharacterDetail(_ character: CharacterModel) {
//        let detailViewModel = CharacterDetailViewModel(character: character)
//        let detailView = CharacterDetailView(viewModel: detailViewModel)
//        let hostingController = UIHostingController(rootView: detailView)
//        navigationController.pushViewController(hostingController, animated: true)
//    }
//    
        func showCharacterDetail(_ character: CharacterModel) {
            let detailViewModel = CharacterDetailViewModel(character: character)
            let detailView = CharacterDetailView(viewModel: detailViewModel)
            let hostingController = UIHostingController(rootView: detailView)
            navigationController.pushViewController(hostingController, animated: true)
        }
    
}
