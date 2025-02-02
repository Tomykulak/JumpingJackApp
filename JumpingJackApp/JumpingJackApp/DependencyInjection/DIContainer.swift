//
//  DIContainer.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

@MainActor
final class DIContainer {
    let coreDataController: CoreDataController
    let userDataService: UserDataService

    // DB Model: UserData
    // DB name: JumpingJackApp
    
    init() {
        self.coreDataController = CoreDataController()
        self.userDataService = UserDataService(moc: coreDataController.container.viewContext)
    }
}
