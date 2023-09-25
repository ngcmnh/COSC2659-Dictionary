/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: 23AMDictionary
 ID: s3907086, s3904422, s3880604, s3904901, s3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 https://dictionaryapi.dev/
 https://gist.github.com/vikaskore/b8e68cb324da31121c8bc6a061e51612
 https://github.com/rckim77/Sudoku
 https://youtu.be/0ytO3wCRKZU?si=ZgDxBYqK_RAJ_pJ0
 https://www.appicon.co/#image-sets
 https://www.flaticon.com/free-icon/books_2704442?term=book&page=1&position=89&origin=tag&related_id=2704442
 https://youtu.be/vzQDKYIKEb8?si=ghJQlGU6RkVpWLv-
 https://stackoverflow.com/questions/69002861/controlling-size-of-texteditor-in-swiftui
 https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
 https://www.youtube.com/watch?v=6b2WAePdiqA
 https://www.youtube.com/watch?v=uqkUumqFiF8
 https://www.youtube.com/watch?v=UeOi5H3HJOE
 https://www.youtube.com/watch?v=8MLdq9kotII
 https://www.youtube.com/watch?v=uhTRQ4TWQ9g
 https://www.youtube.com/watch?v=FFWP7eXn0ck
 https://matteomanferdini.com/mvvm-pattern-ios-swift/
 https://developer.apple.com/design/human-interface-guidelines/typography#Specifications
 https://developer.apple.com/design/human-interface-guidelines/dark-mode
 https://developer.apple.com/design/human-interface-guidelines/layout
 https://developer.apple.com/design/human-interface-guidelines/text-fields
 https://developer.apple.com/design/human-interface-guidelines/navigation-bars
 */

import Foundation
import Firebase

class UserViewModel: ObservableObject, ViewModel {
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
    
    
    // UI Controller
    var horizontalPadding : CGFloat {
        if isIpad {
            return 150
        } else {
            return 25
        }
    }
    
    var verticalPadding : CGFloat {
        if isIpad {
            return 30
        } else {
            return 18
        }
    }
    
    var profilePicSize: CGFloat {
        if isIpad {
            return screenWidth/5
        } else {
            return screenWidth/5*2
        }
    }
}
