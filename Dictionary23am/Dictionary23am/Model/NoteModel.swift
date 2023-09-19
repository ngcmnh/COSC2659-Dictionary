/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Minh Anh
 ID: S3931980
 Created date: 14/09/2023
 Last modified: /09/2023
 Acknowledgement:
 
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

