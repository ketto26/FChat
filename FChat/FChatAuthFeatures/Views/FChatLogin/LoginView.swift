//
//  LoginView.swift
//  FChat
//
//  Created by Keto Nioradze on 02.09.25.
//

import SwiftUI

struct LoginView: View {
    // FIX: Using @EnvironmentObject
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("Log In")
                .font(.title)
            
            // FIX: The binding syntax is correct with @EnvironmentObject
            TextField("Email", text: $authVM.state.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            // FIX: The binding syntax is correct with @EnvironmentObject
            SecureField("Password", text: $authVM.state.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Sign In") {
                Task {
                    await authVM.signIn()
                    if authVM.state.isSignedIn {
                        coordinator.popToRoot()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let errorMessage = authVM.state.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .gradientBackground()
    }
}


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
        .environmentObject(Coordinator())
}
