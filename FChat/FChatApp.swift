//
//  FChatApp.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct FChatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // FIX: Using @StateObject to own the ObservableObject
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            FlowCoordinatorView()
                // FIX: Using .environmentObject() to inject the ObservableObject
                .environmentObject(authVM)
                .environmentObject(coordinator)
        }
    }
}
