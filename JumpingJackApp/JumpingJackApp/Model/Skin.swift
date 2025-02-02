//
//  Skin.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 30.12.2024.
//
import Foundation

struct Skin: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let price: Int32
    
    init(id: UUID = UUID(), name: String, imageName: String, price: Int32) {
            self.id = id
            self.name = name
            self.imageName = imageName
            self.price = price
        }
}

// Mock data
extension Skin {
    static let mock = Skin(
        id: UUID(), // Add an explicit id for mock data
        name: "default_skin",
        imageName: "jack0",
        price: 10
    )
}
