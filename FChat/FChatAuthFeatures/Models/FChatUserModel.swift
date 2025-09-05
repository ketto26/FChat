//
//  FChatUserModel.swift
//  FChat
//
//  Created by Keto Nioradze on 01.09.25.
//

import Foundation
import FirebaseAuth

struct ChatUser: Identifiable, Codable {
    var id: String          // Firebase UID
    var email: String
    var displayName: String?
    var avatarURL: String?
}
