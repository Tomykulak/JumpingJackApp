//
//  BackBarButton.swift
//  JumpingJackApp
//
//  Created by Adam Smekal on 26.01.2025.
//

import SwiftUI

struct BackBarButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
            dismiss() // Zavře aktuální obrazovku
        }) {
            HStack {
                Image(systemName: "arrow.left.circle") // Ikona šipky
                    .foregroundColor(Color.toolbarTextColor) // Nastaví barvu ikony na černou
                Text("Back") // Text tlačítka
                    .foregroundColor(Color.toolbarTextColor) // Nastaví barvu textu na černou
            }
        }
    }
}

