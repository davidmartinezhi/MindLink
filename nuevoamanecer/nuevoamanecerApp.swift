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
            // ContentView()
            PictogramEditor(pictoCollectionPath: "basePictograms", catCollectionPath: "baseCategories")
        }
    }
}




