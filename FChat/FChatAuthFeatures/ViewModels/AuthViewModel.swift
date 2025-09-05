//
//  AuthViewModel.swift
//  FChat
//
//  Created by Keto Nioradze on 02.09.25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn // Don't forget to import GoogleSignIn!

final class AuthViewModel: ObservableObject {
    
    @Published var state = State()
    
    struct State {
        var email = ""
        var password = ""
        var user: ChatUser?
        var isLoading: Bool = false
        var errorMessage: String?
        var isSignedIn: Bool = Auth.auth().currentUser != nil
    }
    
    private let authService: AuthServiceProtocol
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
        
        self.authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let firebaseUser = user {
                self?.state.user = ChatUser(id: firebaseUser.uid, email: firebaseUser.email ?? "", displayName: firebaseUser.displayName)
                self?.state.isSignedIn = true
            } else {
                self?.state.user = nil
                self?.state.isSignedIn = false
            }
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    @MainActor
    func signUp() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        do {
            let user = try await authService.signUp(email: state.email, password: state.password)
            state.user = user
            state.isSignedIn = true
            state.email = ""
            state.password = ""
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signIn() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        do {
            let user = try await authService.signIn(email: state.email, password: state.password)
            state.user = user
            state.isSignedIn = true
            state.email = ""
            state.password = ""
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signOut() {
        do {
            try authService.signOut()
            state.user = nil
            state.isSignedIn = false
        } catch {
            state.errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signInWithGoogle() async {
        state.isLoading = true
        state.errorMessage = nil
        defer { state.isLoading = false }
        
        do {
            guard let topVC = getRootViewController() else {
                throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find root view controller."])
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
            
            // This guard let remains as idToken can still be optional
            guard let idToken = result.user.idToken?.tokenString else {
                throw NSError(domain: "AuthError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not get Google ID Token."])
            }
            
            // FIX: Removed the 'guard let' because the compiler says tokenString is a non-optional String
            let accessToken = result.user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let firebaseResult = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = firebaseResult.user
            self.state.user = ChatUser(id: firebaseUser.uid, email: firebaseUser.email ?? "", displayName: firebaseUser.displayName)
            self.state.isSignedIn = true
            
        } catch {
            print("Google Sign-In Error: \(error.localizedDescription)")
            self.state.errorMessage = error.localizedDescription
        }
    }
    
    private func getRootViewController() -> UIViewController? {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let root = screen.windows.first?.rootViewController else {
            return nil
        }
        return root
    }
}
