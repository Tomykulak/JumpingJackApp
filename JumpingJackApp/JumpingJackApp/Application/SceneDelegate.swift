//
//  SceneDelegate.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import UIKit
import FacebookCore
import SwiftUI
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    var container: DIContainer!
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Initialize DIContainer and AppCoordinator
        let container = DIContainer()
        let appWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
        appWindow.windowScene = windowScene

        appCoordinator = AppCoordinator(window: appWindow, container: container, delegate: _delegate)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        // Pass the URL to Facebook SDK for processing
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
