//
//  FlowCoordinatorView.swift
//  FChat
//
//  Created by Keto Nioradze on 02.09.25.
//

import SwiftUI

struct FlowCoordinatorView: View {
    // FIX: Using @EnvironmentObject
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                if authVM.state.isSignedIn {
                    HomeScreenView()
                } else {
                    SignUpView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signUp:
                    SignUpView()
                case .login:
                    LoginView()
                case .home:
                    HomeScreenView()
                case .chat(let chatID):
                    Text("Chat with ID: \(chatID)")
                }
            }
        }
    }
}


