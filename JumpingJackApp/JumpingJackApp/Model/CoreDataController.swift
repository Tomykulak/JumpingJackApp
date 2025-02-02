//
//  PersistenceController.swift
//  JumpingJackApp
//
//  Created by Tomáš Okruhlica on 26.12.2024.
//

import Foundation
import CoreData


class CoreDataController: ObservableObject{
    
    //Container to save only locally
    let container = NSPersistentContainer(name: "JumpingJackApp")

    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to create container: \(error.localizedDescription)")
            }
        }
    }
}

