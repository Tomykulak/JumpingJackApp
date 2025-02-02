//
//  HomeViewModel.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import UIKit
import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    @Published private(set) var state = State()
    @Published var selectedSkin: Skin?
    @Published var sortedLeaderboard: [FireBaseUser] = []
    
    private weak var coordinator: HomeViewEventHandling?
    private let userDataService: UserDataServicing

    init(
        userDataService: UserDataServicing,
        coordinator: HomeViewEventHandling? = nil
    ) {
        self.userDataService = userDataService
        self.coordinator = coordinator

        // Initialize default skins in CoreData
        self.userDataService.initializeDefaultSkins()
    }

    func send(_ action: Action) {
        switch action {
        case .didAppear:
            // Zkontroluj, zda uživatel již existuje v CoreData
            if let user = userDataService.fetchUser() {
                // Načti existujícího uživatele
                state.user = user
            } else {
                initializeNewUser()
            }

        case .saveUser:
            userDataService.saveUserData(user: state.user)

        case .didTapPlayButton:
            coordinator?.handle(event: .play)

        case .didTapShopButton:
            coordinator?.handle(event: .shop)

        case .didTapSkinDetailButton(let skin):
            coordinator?.handle(event: .skinDetail(skin))

        case .didUserBuySkin(let user, let skin):
            guard user.coins >= skin.price else {
                print("Not enough coins to buy the skin.")
                return
            }

            if !state.user.ownedSkins.contains(where: { $0.id == skin.id }) {
                userDataService.userBuySkin(user: user, skin: skin)
                if let updatedUser = userDataService.fetchUser() {
                    state.user = updatedUser // Update user state
                } else {
                    print("Failed to fetch updated user data after skin purchase.")
                }
            } else {
                print("User already owns this skin.")
            }

        case .didTapProfileButton:
            coordinator?.handle(event: .profile)
        // play the game
        case .didTapGameButton:
            coordinator?.handle(event: .game)
        // fetch skins for the shop
        case .fetchAvailableSkins:
            // Fetch skins from CoreData
            let fetchedSkins = userDataService.fetchAvailableSkins()
            // Update the state with the fetched skins
            state.availableSkins = fetchedSkins
            
        // set active skin
        case .setUserActiveSkin(let skin):
            userDataService.setActiveSkin(for: state.user, skin: skin)
            if let updatedUser = userDataService.fetchUser() {
                state.user = updatedUser
            }
            
        // add coins for the user
        case .addCoins(let amount):
            userDataService.addCoins(to: state.user, amount: amount)
            if let updatedUser = userDataService.fetchUser() {
                state.user = updatedUser
            }
        // update highest score of the user
        case .highestScore(let score):
            userDataService.checkAndReplaceHighestScore(to: state.user, score: score)
            
            if let updatedUser = userDataService.fetchUser() {
                state.user = updatedUser
            }
            
        case .setUserName(let name):
            userDataService.updateUserName(to: state.user, name: name)
            if let updatedUser = userDataService.fetchUser() {
                state.user = updatedUser
            }
        case .resetUserSkins:
            state.user.activeSkin = nil
            state.user.ownedSkins = []
            userDataService.saveUserData(user: state.user)

            // Fetch updated user data
            if let updatedUser = userDataService.fetchUser() {
                state.user = updatedUser
            }
            
        case .redirectToHome:
            coordinator?.handle(event: .home)
        case .fetchLeaderboard:
        Task {
            let users = await userDataService.sortUsersInLeaderboardByScore()
                await MainActor.run {
                    self.sortedLeaderboard = users
                }
            }
        case .setFacebookId:
            Task {
                if let facebookId = await FacebookLoginButton.fetchUserId() {
                    await userDataService.setFacebookIdForUser(user: state.user, facebookId: facebookId)
                }
            }
        case .saveUserToFirestore:
            Task {
                await userDataService.addUserToFirestore(user: state.user)
            }
        case .fetchFirestoreUser:
            Task {
                if let user = await userDataService.fetchFirebaseUser(byFacebookId: state.user.facebookId ?? "") {
                    await MainActor.run {
                        var ownedSkins: [Skin] = []

                        if user.ownedSkins.contains("Skin 1") {
                            ownedSkins.append(Skin(name: "Skin 1", imageName: "jack0", price: 10))
                        }
                        if user.ownedSkins.contains("Skin 2") {
                            ownedSkins.append(Skin(name: "Skin 2", imageName: "jack1", price: 20))
                        }
                        if user.ownedSkins.contains("Skin 3") {
                            ownedSkins.append(Skin(name: "Skin 3", imageName: "jack2", price: 81))
                        }

                        state.user = User(
                            name: user.name,
                            coins: user.coins,
                            gems: 0,
                            highestScore: user.highestScore,
                            ownedSkins: ownedSkins
                        )
                        userDataService.saveUserData(user: state.user)
                    }
                }
            }
        }
    }
    private func initializeNewUser() {
        // Vytvoření nového uživatele s výchozím skinem
        let defaultSkin = Skin(name: "Skin 1", imageName: "jack0", price: 10)

        // Vytvoř nového uživatele
        let newUser = User(
            name: "New Player",
            coins: 100,
            gems: 0,
            highestScore: 0,
            activeSkin: defaultSkin,
            ownedSkins: [defaultSkin]
        )

        // Ulož nového uživatele
        userDataService.saveUserData(user: newUser)
        state.user = newUser
    }
}

// MARK: Event
extension HomeViewModel {
    enum Event {
        case play
        case shop
        case skinDetail(Skin)
        case profile
        case game
        case home
    }
}

// MARK: Action
extension HomeViewModel {
    enum Action {
        // load user data
        case didAppear
        
        // save user
        case saveUser
        
        // open shop
        case didTapShopButton
        
        // open the levels view endless/story options
        case didTapPlayButton
        
        // open sheet with skin detail
        case didTapSkinDetailButton(Skin)
        
        // load skins in shop
        case fetchAvailableSkins
        
        // set active skin for the user
        case setUserActiveSkin(Skin)
        
        // resets skins of the user
        case resetUserSkins
        
        // add coins to user
        case addCoins(Int32)
        
        case highestScore(Int32)
        
        case setUserName(String)
        
        // buy a skin in the shop
        case didUserBuySkin(User, Skin)
        
        // open profile view with settings
        case didTapProfileButton
        
        // open the game
        case didTapGameButton
        
        // redirect to home view
        case redirectToHome
        
        // get data from leaderboard
        case fetchLeaderboard
        
        // set facebook id
        case setFacebookId
        
        // save user to firestore
        case saveUserToFirestore
        
        // fetch firestore user
        case fetchFirestoreUser
        
    }
}

// MARK: State
extension HomeViewModel {
    struct State {
        // user data
        var user: User = User.mock
        // skins in the shop
        var availableSkins: [Skin] = []
    }
}
