//
//  HomeViewEventHandling.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 29.12.2024.
//

protocol HomeViewEventHandling: AnyObject {
    func handle(event: HomeViewModel.Event)
}
