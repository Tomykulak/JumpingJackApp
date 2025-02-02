//
//  AppCoordinator.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import UIKit
import UIKit
import SwiftUI

@MainActor
final class AppCoordinator {
    let container: DIContainer
    var childCoordinators = [Coordinator]()
    var rootCoordinator: Coordinator?
    let window: UIWindow
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    init(window: UIWindow, container: DIContainer, delegate: UIApplicationDelegateAdaptor<AppDelegate>) {
        self.window = window
        self.container = container
        self._delegate = delegate
        start(container: container)
    }
}

extension AppCoordinator {
    func start(container: DIContainer) {
        let navigationController = UINavigationController()
        let coordinator = JumpingJackCoordinator(
            navigationController: navigationController,
            container: container
        )
        childCoordinators.append(coordinator)
        rootCoordinator = coordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
