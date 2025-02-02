//
//  ShopViewEventHandling.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 02.01.2025.
//

protocol ShopViewEventHandling: AnyObject {
    func handle(event: ShopViewModel.Event)
}
