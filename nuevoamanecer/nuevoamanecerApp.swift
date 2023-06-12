//
//  nuevoamanecerApp.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 11/05/23.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct nuevoamanecerApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // PictogramEditor(userId: "hcx4EZbRyth07y5gVYOm")
            let pcPath1: String = "basePictograms"
            let cPath1: String = "baseCategories"
            let pcPath2: String = "User/hcx4EZbRyth07y5gVYOm/pictograms"
            let cPath2: String = "User/hcx4EZbRyth07y5gVYOm/categories"
            
            PictogramEditor(pictoCollectionPath: pcPath2, catCollectionPath: cPath2)
            
            // Communicator(pictoCollectionPath: pcPath1, catCollectionPath: cPath1)
    
            // DoubleCommunicator(pictoCollectionPath1: pcPath1, catCollectionPath1: cPath1, pictoCollectionPath2: pcPath2, catCollectionPath2: cPath2)
        }
    }
}




