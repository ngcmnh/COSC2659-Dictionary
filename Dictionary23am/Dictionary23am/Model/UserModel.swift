//
//  UserModel.swift
//  Dictionary23am
//
//  Created by ngminh on 16/09/2023.
//

import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var imgUrl: String
    var username: String
    var bio: String

    // Initialize from a Firestore document
    init(documentData: [String: Any]) {
        self.id = documentData["id"] as? String ?? ""
        self.email = documentData["email"] as? String ?? ""
        self.imgUrl = documentData["imgUrl"] as? String ?? ""
        self.username = documentData["username"] as? String ?? ""
        self.bio = documentData["bio"] as? String ?? ""
    }
    
    // Default values for user creation
    init(id: String, email: String) {
        self.id = id
        self.email = email
        self.imgUrl = ""  // Default empty, to be set later by the user
        self.username = ""  // Default empty, to be set later by the user
        self.bio = ""   // Default empty, to be set later by the user
    }
}
