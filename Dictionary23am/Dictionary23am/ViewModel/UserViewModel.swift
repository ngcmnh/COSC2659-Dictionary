//
//  UserViewModel.swift
//  Dictionary23am
//
//  Created by ngminh on 17/09/2023.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    private var db = Firestore.firestore()
    
    init() {
        if let user = Auth.auth().currentUser {
            self.currentUser = User(id: user.uid, email: user.email ?? "")
            fetchUserDetails()
        }
    }

    func setUserDetails(userID: String, email: String) {
        self.currentUser = User(id: userID, email: email)
        fetchUserDetails()
    }

    // Fetch user details from Firestore
    private func fetchUserDetails() {
        guard let userID = self.currentUser?.id else { return }

        db.collection("user").document(userID).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data() {
                let imgUrl = data["imgUrl"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let bio = data["bio"] as? String ?? ""
                
                // Update user object with fetched details
                self.currentUser?.imgUrl = imgUrl
                self.currentUser?.username = username
                self.currentUser?.bio = bio
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Update name and bio in Firestore
    func updateNameAndBio(imgUrl: String, username: String, bio: String) {
        guard let userID = self.currentUser?.id else { return }
        
        // Update the fields in Firestore
        let db = Firestore.firestore()
        db.collection("user").document(userID).setData([
            "imgUrl": imgUrl,
            "username": username,
            "bio": bio
        ], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                self.currentUser?.imgUrl = imgUrl
                self.currentUser?.username = username
                self.currentUser?.bio = bio
            }
        }
    }
}
