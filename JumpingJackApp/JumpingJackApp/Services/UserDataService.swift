//
//  GameService.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import CoreData
import Foundation
import UIKit
import FirebaseCore
import SwiftUI
import FirebaseFirestore

protocol UserDataServicing {
    func fetchUser() -> User?
    func saveUserData(user: User)
    func userBuySkin(user: User, skin: Skin)
    func initializeDefaultSkins()
    func fetchAvailableSkins() -> [Skin]
    func setActiveSkin(for user: User, skin: Skin)
    func addCoins(to user: User, amount: Int32)
    func checkAndReplaceHighestScore(to user: User, score: Int32)
    func updateUserName(to user: User, name: String)
    func deleteSkin(by name: String)
    func fetchFirebaseUserData() async -> [FireBaseUser]
    func sortUsersInLeaderboardByScore() async -> [FireBaseUser]
    func setFacebookIdForUser(user: User, facebookId: String) async
    func addUserToFirestore(user: User) async -> Bool
    func fetchFirebaseUser(byFacebookId facebookId: String) async -> FireBaseUser?
}

final class UserDataService: UserDataServicing {
    
    func fetchFirebaseUserData() async -> [FireBaseUser] {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("users").getDocuments()
            let users: [FireBaseUser] = snapshot.documents.compactMap { document in
                // Bezpečné načítání všech atributů
                let id = document["id"] as? String ?? ""
                let name = document["name"] as? String ?? "Unknown"
                let coins = document["coin"] as? Int32 ?? 0
                let highestScore = document["highestScore"] as? Int32 ?? 0
                let ownedSkins = document["skins"] as? [String] ?? []
                
                // Vytvoření instance FireBaseUser
                return FireBaseUser(
                    id: id,
                    name: name,
                    coins: coins,
                    highestScore: highestScore,
                    ownedSkins: ownedSkins
                )
            }
            return users
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return [] // Vrať prázdné pole v případě chyby
        }
    }
    
    func fetchFirebaseUser(byFacebookId facebookId: String) async -> FireBaseUser? {
        let db = Firestore.firestore()
        do {
            // Dotaz na konkrétní dokument podle facebookId
            let document = try await db.collection("users").document(facebookId).getDocument()
            
            guard let data = document.data() else {
                print("No data found for Facebook ID: \(facebookId)")
                return nil
            }
            
            // Bezpečné načítání atributů
            let id = data["id"] as? String ?? ""
            let name = data["name"] as? String ?? "Unknown"
            let coins = data["coins"] as? Int32 ?? 0
            let highestScore = data["highestScore"] as? Int32 ?? 0
            let ownedSkins = data["skins"] as? [String] ?? []
            
            // Vytvoření instance FireBaseUser
            return FireBaseUser(
                id: id,
                name: name,
                coins: coins,
                highestScore: highestScore,
                ownedSkins: ownedSkins
            )
        } catch {
            print("Error fetching user for Facebook ID \(facebookId): \(error.localizedDescription)")
            return nil // Vrať nil v případě chyby
        }
    }

    
    func addUserToFirestore(user: User) async -> Bool {
        guard user.facebookId != "Unknown fb id" else {
            return false
        }
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "id": user.facebookId ?? "Unknown fb id",
            "name": user.name,
            "coins": user.coins,
            "highestScore": user.highestScore,
            "skins": user.ownedSkins.map { $0.name } // Převod Skin objektů na jejich názvy
        ]

        do {
            // Přidání uživatele do Firestore s jeho Facebook ID jako dokument ID
            guard let facebookId = user.facebookId else {
                print("User does not have a Facebook ID.")
                return false
            }
            try await db.collection("users").document(facebookId).setData(userData)
            print("User added to Firestore successfully.")
            return true
        } catch {
            print("Error adding user to Firestore: \(error.localizedDescription)")
            return false
        }
    }


    func setFacebookIdForUser(user: User, facebookId: String) async {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            if let userData = try moc.fetch(request).first {
                userData.facebookId = facebookId
                save() // Save changes to CoreData
            } else {
                print("User not found in CoreData.")
            }
        } catch {
            print("Error updating user facebookId: \(error.localizedDescription)")
        }
    }
    
    func sortUsersInLeaderboardByScore() async -> [FireBaseUser] {
        // Načti uživatele z Firestore
        let users = await fetchFirebaseUserData()
        
        // Seřaď uživatele podle skóre (highestScore) od nejvyššího po nejnižší
        let sortedUsers = users.sorted { $0.highestScore > $1.highestScore }
        
        return sortedUsers
    }

    
    private let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }

    func fetchUser() -> User? {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        do {
            if let userData = try moc.fetch(request).first {
                let user = User(
                    id: userData.id ?? UUID(),
                    name: userData.name ?? "Unknown name",
                    facebookId: userData.facebookId ?? "Unknown fb id",
                    coins: userData.coins,
                    gems: userData.gems,
                    highestScore: userData.highestScore,
                    activeSkin: userData.activeSkin.map {
                        Skin(
                            name: $0.name ?? "Skin 1",
                            imageName: $0.imageName ?? "jack0",
                            price: $0.price
                        )
                    },
                    ownedSkins: (userData.ownedSkins as? Set<SkinData>)?.map {
                        Skin(
                            name: $0.name ?? "default_skin",
                            imageName: $0.imageName ?? "jack0",
                            price: $0.price
                        )
                    } ?? []
                )
                return user
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveUserData(user: User) {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)

        do {
            let userData = try moc.fetch(request).first ?? UserData(context: moc)

            userData.id = user.id
            userData.name = user.name
            userData.facebookId = user.facebookId
            userData.coins = user.coins
            userData.gems = user.gems
            userData.highestScore = user.highestScore

            // Update active skin
            if let activeSkin = user.activeSkin {
                let skinData = fetchSkin(by: activeSkin.name) ?? SkinData(context: moc)
                skinData.id = activeSkin.id
                skinData.name = activeSkin.name
                skinData.imageName = activeSkin.imageName
                skinData.price = activeSkin.price
                userData.activeSkin = skinData
            } else {
                userData.activeSkin = nil // Clear active skin
            }

            // Update owned skins
            let ownedSkins = user.ownedSkins.map { skin in
                let skinData = fetchSkin(by: skin.name) ?? SkinData(context: moc)
                skinData.id = skin.id
                skinData.name = skin.name
                skinData.imageName = skin.imageName
                skinData.price = skin.price
                return skinData
            }
            userData.ownedSkins = NSSet(array: ownedSkins) // Convert to NSSet

            save()
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }

    
    func addCoins(to user: User, amount: Int32) {
        // fetch db data
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            if let userData = try moc.fetch(request).first {
                userData.coins += amount
                save() // Save changes to CoreData
            } else {
                print("User not found in CoreData.")
            }
        } catch {
            print("Error updating user coins: \(error.localizedDescription)")
        }
    }
    
    func checkAndReplaceHighestScore(to user: User, score: Int32) {
        // fetch db data
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        if let userData = try? moc.fetch(request).first, score > userData.highestScore {
            userData.highestScore = score
            save()
        } else {
            print("Score not updated. Either user not found or score is not higher.")
        }
    }
    
    func updateUserName(to user: User, name: String) {
        // fetch db data
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            if let userData = try moc.fetch(request).first {
                userData.name = name
                save() // Save changes to CoreData
            } else {
                print("User not found in CoreData.")
            }
        } catch {
            print("Error updating user coins: \(error.localizedDescription)")
        }
    }

    func userBuySkin(user: User, skin: Skin) {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)

        do {
            if let userData = try moc.fetch(request).first {
                guard userData.coins >= skin.price else {
                    print("Not enough coins to buy the skin.")
                    return
                }

                if let ownedSkins = userData.ownedSkins as? Set<SkinData>,
                   ownedSkins.contains(where: { $0.name == skin.name }) {
                    print("User already owns this skin.")
                    return
                }

                userData.coins -= skin.price
                let skinData = fetchSkin(by: skin.name) ?? SkinData(context: moc)
                skinData.id = skin.id
                skinData.name = skin.name
                skinData.imageName = skin.imageName
                skinData.price = skin.price

                var ownedSkins = userData.ownedSkins as? Set<SkinData> ?? Set()
                ownedSkins.insert(skinData)
                userData.ownedSkins = NSSet(set: ownedSkins)

                save()
                print("Skin purchased successfully.")
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
        }
    }

    
    func fetchAvailableSkins() -> [Skin] {
        let request = NSFetchRequest<SkinData>(entityName: "SkinData")

        do {
            let skinDataArray = try moc.fetch(request)
            return skinDataArray.map {
                Skin(
                    id: $0.id ?? UUID(), // Ensure consistent id
                    name: $0.name ?? "Skin 1",
                    imageName: $0.imageName ?? "jack0",
                    price: $0.price
                )
            }
        } catch {
            print("Error fetching skins: \(error.localizedDescription)")
            return []
        }
    }


    func setActiveSkin(for user: User, skin: Skin) {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)

        do {
            if let userData = try moc.fetch(request).first {
                guard let ownedSkins = userData.ownedSkins as? Set<SkinData>,
                      ownedSkins.contains(where: { $0.name == skin.name }) else {
                    print("Skin not owned by the user.")
                    return
                }

                let skinData = fetchSkin(by: skin.name) ?? SkinData(context: moc)
                userData.activeSkin = skinData

                save()
                print("Active skin updated successfully.")
            }
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    // just in case to delete an unwanted skin
    func deleteSkin(by name: String) {
        let request = NSFetchRequest<SkinData>(entityName: "SkinData")
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            let skins = try moc.fetch(request)
            for skin in skins {
                moc.delete(skin)
            }
            save() // Save changes
        } catch {
            print("Error deleting skin: \(error.localizedDescription)")
        }
    }

    func initializeDefaultSkins() {
        let defaultSkins = [
            Skin(name: "Skin 1", imageName: "jack0", price: 10),
            Skin(name: "Skin 2", imageName: "jack1", price: 20),
            Skin(name: "Skin 3", imageName: "jack2", price: 81)
        ]

        for skin in defaultSkins {
            // Fetch existing skin by name or id
            if fetchSkin(by: skin.name) == nil {
                let skinData = SkinData(context: moc)
                skinData.id = skin.id
                skinData.name = skin.name
                skinData.imageName = skin.imageName
                skinData.price = skin.price
            }
        }

        save()
    }


    private func fetchSkin(by name: String) -> SkinData? {
        let request = NSFetchRequest<SkinData>(entityName: "SkinData")
        request.predicate = NSPredicate(format: "name == %@", name)

        do {
            return try moc.fetch(request).first
        } catch {
            print("Error fetching skin data: \(error.localizedDescription)")
        }
        return nil
    }
}

// Future saving game data
private extension UserDataService {
    func save(){
        if moc.hasChanges{
            do{
                try moc.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }

}
