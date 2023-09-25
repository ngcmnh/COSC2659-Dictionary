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

import SwiftUI
import Firebase

struct NoteListView: View {
    @StateObject var viewModel = NoteListViewModel()
    
    @State var tempNote: NoteModel
    @State var noteStatus: NoteStatus = .none
    @State var prevStatus: NoteStatus = .none
    @State var showingAddNoteView = false
    @State private var action: Int? = 0
    let currentUserID = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.notes) { $note in
                    // Within the NoteListView's ForEach loop:
                    NavigationLink(destination:  NoteDetailView(note: $note, noteStatus: $noteStatus).navigationBarBackButtonHidden(true)) {
                        NoteRowView(noteContent: note.title)
                    }
                    // delete note by swiping note row
                    .swipeActions {
                        Button {
                            withAnimation {
                                if let index = viewModel.notes.firstIndex(of: note) {
                                    // Call the delete function from Firestore
                                    viewModel.deleteNoteFromFirestore(note: viewModel.notes[index]) { success in
                                        if success {
                                            withAnimation {
                                                viewModel.notes.remove(at: index)
                                            }
                                            print("Note deleted successfully!")
                                        } else {
                                            print("Failed to delete note from Firestore.")
                                            // Handle the error or notify the user
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Delete")
                                .font(Font(viewModel.body))
                                .foregroundColor(.white) // Text color
                                .padding(.horizontal, viewModel.horizontalPadding) // Add some padding around the text
                                .padding(.vertical, viewModel.verticalPadding)
                                .background(Color.red) // Background color
                                .cornerRadius(5) // Optional: Round the corners of the button
                        }
                        .tint(.red)
                    }
                }
                Text("Number of Notes: \(viewModel.notes.count)") // This line displays the count of notes.
                    .padding(.horizontal, viewModel.horizontalPadding)
                    .padding(.vertical, viewModel.verticalPadding)
                    .font(Font(viewModel.footnote))
                    .foregroundColor(Color("Text").opacity(0.6))
            }
            .background{    // Invisible navigation link activated when the add note button is clicked
                NavigationLink("", destination: NoteDetailView(note: $tempNote, noteStatus: $noteStatus).navigationBarBackButtonHidden(true), tag: 1, selection: $action)
                    .opacity(0) // Makes it invisible
            }
            .toolbar {
                Button {
                    tempNote = NoteModel(id: UUID(), userId: currentUserID!, title: "Untitled", dateCreated: Date(), body: "empty...")
                    noteStatus = .create
                    self.action = 1
                } label: {
                    Image(systemName: "plus")
                        .font(Font(viewModel.body))
                        .foregroundColor(Color("Primary"))
                }
            }
        }
        .onChange(of: noteStatus, perform: { newStatus in
            // add to list after creating new note
            if prevStatus == .create && newStatus == .none {
                viewModel.notes.insert(tempNote, at: 0)
            }
            prevStatus = newStatus
        })
    }
}


struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(tempNote: NoteModel.sample, noteStatus: .none, showingAddNoteView: false)
    }
}
