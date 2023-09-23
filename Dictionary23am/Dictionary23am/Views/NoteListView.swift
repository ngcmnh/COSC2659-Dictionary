/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Dang Cong Minh, Tran Minh Anh
 ID: S390494, S3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
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
                    //viewModel.saveToFirestore(note: tempNote, userId: currentUserID!, completion: true)
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
