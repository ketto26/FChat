//
//  AuthServiceProtocol.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> ChatUser
    func signIn(email: String, password: String) async throws -> ChatUser
    func signOut() throws
}

final class FirebaseAuthService: AuthServiceProtocol {
    
    func signUp(email: String, password: String) async throws -> ChatUser {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = result.user
        return ChatUser(id: user.uid, email: user.email ?? "", displayName: user.displayName)
    }
    
    func signIn(email: String, password: String) async throws -> ChatUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = result.user
        return ChatUser(id: user.uid, email: user.email ?? "", displayName: user.displayName)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
