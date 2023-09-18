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

class NoteModel : Identifiable, ObservableObject, Equatable {
    var id: UUID
    var title: String
    var dateCreated: Date
    var body: String
    
    init(id: UUID, title: String, dateCreated: Date, body: String) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.body = body
    }
    
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
        return
            lhs.id == rhs.id
    }
}

extension NoteModel {
    static var sample = NoteModel(id: UUID(), title: "Untitled", dateCreated: Date(), body: "Note here")
}
