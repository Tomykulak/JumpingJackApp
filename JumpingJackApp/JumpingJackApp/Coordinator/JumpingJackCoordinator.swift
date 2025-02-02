//
//  JumpingJackCoordinator.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import Foundation
import SwiftUI

@MainActor
final class JumpingJackCoordinator: GameViewEventHandling {
    let container: DIContainer
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private var isLoading: Bool = true
    
    private lazy var viewModel: HomeViewModel = HomeViewModel(
           userDataService: container.userDataService,
           coordinator: self
       )
    
    init(navigationController: UINavigationController, container: DIContainer) {
       self.container = container
       self.navigationController = navigationController

       start()
   }
}

// Setup script to enable the first screen
extension JumpingJackCoordinator: @preconcurrency Coordinator {
    func start() {
        let splashControllerView = makeSplashView()
        navigationController.setViewControllers([splashControllerView], animated: false)

        let signInViewController = makeHomeView()
        isLoading = false
        if !isLoading {
            navigationController.setViewControllers([signInViewController], animated: true)
            isLoading = true
        }
        
        // remove navigation bar
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}


// MARK: Factories
// Make as many views here as you`d like
private extension JumpingJackCoordinator {
    // Game view for the actual game
    func makeGameView() -> UIViewController {
        let view = GameView(
            homeViewModel: self.viewModel
        )
        return UIHostingController(rootView: view)
    }
    
    // Levels view before the game begins
    func makeLevelView() -> UIViewController {
        let view = LevelView()
        return UIHostingController(rootView: view)
    }
    
    // Loading screen on start of the app
    func makeSplashView() -> UIViewController {
        let view = SplashView(
            
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        return UIHostingController(rootView: view)
    }
    
    // Shop view with skins
    func makeShopView() -> UIViewController {
        let view = ShopView(
            homeViewModel: self.viewModel
        )
        navigationController.setNavigationBarHidden(true, animated: false)

        return UIHostingController(rootView: view)
    }
    
    func makeSkinDetailView(skin: Skin) -> UIViewController {
        let view = SkinDetailView(
            skin: skin,
            homeViewModel: self.viewModel
        )
        return UIHostingController(rootView: view)
    }

    
    // Profile view editing user name etc.
    func makeProfileView() -> UIViewController {
        let view = ProfileView(
            viewModel: self.viewModel
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)

        return UIHostingController(rootView: view)
    }
    
    // Home view after splash screen
    func makeHomeView() -> UIViewController {
        let view = HomeView(
            homeViewModel: self.viewModel
        )
        return UIHostingController(rootView: view)
    }
    
    func makeLoadingView() -> UIViewController{
        let view = LoadingView()
        return UIHostingController(rootView: view)
    }
}

// MARK: Navigating
extension JumpingJackCoordinator: @preconcurrency HomeViewEventHandling {
    func handle(event: HomeViewModel.Event){
        switch event {
        case .play:
            let viewController = makeLevelView()
            navigationController.pushViewController(viewController, animated: true)
        case .shop:
            let viewController = makeShopView()
            navigationController.pushViewController(viewController, animated: true)
        case .skinDetail(let skin):
            let viewController = makeSkinDetailView(skin: skin)
            navigationController.present(viewController, animated: true)
        case .profile:
            let viewController = makeProfileView()
            navigationController.pushViewController(viewController, animated: true)
        case .game:
            let loadingControllerView = makeLoadingView()
            navigationController
                .pushViewController(loadingControllerView, animated: true)
            let gameViewController = makeGameView()
            isLoading = false
            if !isLoading {
                navigationController
                    .pushViewController(gameViewController, animated: true)
                isLoading = true
            }
            self.navigationController.setViewControllers(
                [self.makeHomeView(), gameViewController],
                animated: true
                )
        case .home:
            let homeViewController = makeHomeView()
            self.navigationController.setViewControllers(
                [self.makeHomeView(), homeViewController],
                animated: true
                )
        }
    }
}
