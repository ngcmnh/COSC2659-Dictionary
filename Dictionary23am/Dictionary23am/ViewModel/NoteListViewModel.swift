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

class NoteListViewModel: ObservableObject, ViewModel{
    @Published var notes: [NoteModel] = []
    let db = Firestore.firestore()

    init() {
        if let userId = Auth.auth().currentUser?.uid {
            fetchNotes(for: userId)
        } else {
            // Handle scenarios when the user is not logged in, if needed
            print("User not logged in")
        }
    }
    
    // Delete Note from Firestore
    func deleteNoteFromFirestore(note: NoteModel, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("note").document(note.id.uuidString)
        docRef.delete() { error in
            if let error = error {
                print("Error deleting note from Firestore: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func addOrUpdateNote(_ note: NoteModel) {
        // Check if the note already exists in the array
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            // Update the note if it exists
            notes[index] = note
        } else {
            // Add the note if it's new
            notes.append(note)
        }
    }

    func saveToFirestore(note: NoteModel, userId: String, completion: @escaping (Bool) -> Void) {
        let noteData: [String: Any] = [
            "id": note.id.uuidString,
            "userId": userId,
            "title": note.title,
            "dateCreated": Timestamp(date: note.dateCreated),
            "body": note.body
        ]

        // Use the userId as a document ID for easier querying
        let docRef = db.collection("note").document(note.id.uuidString)
        docRef.setData(noteData) { error in
            if let error = error {
                print("Error writing note to Firestore: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func fetchNotes(for userId: String) {
        self.notes.removeAll()   // Clear notes array to fetch new ones
        db.collection("note")
            .whereField("userId", isEqualTo: userId)
            .getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print("Error fetching notes: \(error)")
                    return
                }

                if let snapshot = snapshot {
                    let fetchedNotes = snapshot.documents.compactMap { document -> NoteModel? in
                        // Convert the document data to NoteModel
                        let data = document.data()
                        let id = UUID(uuidString: data["id"] as? String ?? "")
                        let userId = data["userId"] as? String
                        let title = data["title"] as? String
                        let body = data["body"] as? String
                        let dateCreated = (data["dateCreated"] as? Timestamp)?.dateValue()

                        if let id = id, let title = title, let body = body, let dateCreated = dateCreated {
                            return NoteModel(id: id, userId: userId!, title: title, dateCreated: dateCreated, body: body)
                        } else {
                            return nil
                        }
                    }
                    self.notes = fetchedNotes
                }
            })
    }

    
    func getNoteList() -> [NoteModel] {
        // API request here
        // ...
        var result : [NoteModel] = []
//        result.append(NoteModel(id: UUID(), title: "Note 1", dateCreated: Date(), body: "Some notes ..."))
//        result.append(NoteModel(id: UUID(), title: "Note 2", dateCreated: Date(), body: "Some more notes ..."))
        return result
    }
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 20
        } else {
            return 10
        }
    }
    
    var verticalPadding: CGFloat {
        if isIpad {
            return 10
        } else {
            return 5
        }
    }
}
