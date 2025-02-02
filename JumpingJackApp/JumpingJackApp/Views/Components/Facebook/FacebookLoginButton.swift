//
//  FacebookLoginButton.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.01.2025.
//

import SwiftUI
import FacebookLogin

struct FacebookLoginButton: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: Context) {
        // You can update the button here if needed
    }
    
    static func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        print("User logged out")
    }
    
    static func fetchUserProfile() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        graphRequest.start() { _, result, error in
           
            guard let userInfo = result as? [String: Any] else { return }
            
            if let email = userInfo["email"] as? String {
                print(email)
            }
            if let name = userInfo["name"] as? String {
                print(name)
            }
            if let id = userInfo["id"] as? String {
                print(id)
            }
        }
    }
    
    static func fetchUserId() async -> String? {
        return await withCheckedContinuation { continuation in
            let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id"])
            graphRequest.start { _, result, error in
                if let error = error {
                    print("Error fetching user ID: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let userInfo = result as? [String: Any],
                      let id = userInfo["id"] as? String else {
                    continuation.resume(returning: nil)
                    return
                }
                
                continuation.resume(returning: id)
            }
        }
    }
    
}
