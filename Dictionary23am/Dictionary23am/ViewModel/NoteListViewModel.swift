/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Dang Cong Minh, Tran Minh Anh
 ID: S3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
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
        self.notes.removeAll()
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
                        // This will depend on how you've set up your NoteModel and its initializers
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
