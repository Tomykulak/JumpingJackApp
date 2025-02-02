//
//  UserData.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var name: String
    var facebookId: String?
    var coins: Int32
    var gems: Int32
    var highestScore: Int32
    var activeSkin: Skin?
    var ownedSkins: [Skin]
}

// Mock data
extension User {
    static let mock = User(
        name: "Default User",
        coins: 100,
        gems: 50,
        highestScore: 0,
        activeSkin: Skin.mock,
        ownedSkins: [Skin.mock]
    )
}
