//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindowAndCoordinator()
        return true
    }
    
    private func setupWindowAndCoordinator() {
        let navigationController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navigationController)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        coordinator?.start()
    }
}
