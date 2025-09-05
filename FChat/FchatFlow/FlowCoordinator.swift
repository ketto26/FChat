//
//  FlowCoordinator.swift
//  FChat
//
//  Created by Keto Nioradze on 02.09.25.
//

import SwiftUI

enum AppRoute: Hashable {
    case signUp
    case login
    case home
    case chat(chatID: String)
}

// FIX: Changed to ObservableObject and @Published for stability
final class Coordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func popToRoot() {
        navigationPath = NavigationPath()
    }
}
