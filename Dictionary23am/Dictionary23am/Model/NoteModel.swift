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

class NoteModel: Identifiable, ObservableObject, Equatable {
    var id: UUID
    var userId: String  // Represents the user who created the note
    var title: String
    var dateCreated: Date
    var body: String
    
    // Initialize from a Firestore document
    init(documentData: [String: Any]) {
        self.id = UUID(uuidString: documentData["id"] as? String ?? "") ?? UUID()
        self.userId = documentData["userId"] as? String ?? ""
        self.title = documentData["title"] as? String ?? ""
        self.dateCreated = (documentData["dateCreated"] as? Timestamp)?.dateValue() ?? Date()
        self.body = documentData["body"] as? String ?? ""
    }
    
    init(id: UUID, userId: String, title: String, dateCreated: Date, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.dateCreated = dateCreated
        self.body = body
    }
    
    // Convert the note model to a dictionary for Firestore
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id.uuidString,
            "userId": userId,
            "title": title,
            "dateCreated": Timestamp(date: dateCreated),
            "body": body
        ]
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension NoteModel {
    static var sample = NoteModel(id: UUID(), userId: "", title: "Untitled", dateCreated: Date(), body: "Note here")
}

