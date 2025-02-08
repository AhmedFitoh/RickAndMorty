//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol CharacterListCoordinatorDelegate: AnyObject {
    func didSelectCharacter(_ character: Character)
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let characterListCoordinator = CharacterListCoordinator(navigationController: navigationController)
        childCoordinators.append(characterListCoordinator)
        characterListCoordinator.start()
    }
}
