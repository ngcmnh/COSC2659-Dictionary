/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Dang Cong Minh, Tran Minh Anh
 ID: S3931980
 Created date: 16/09/2023
 Last modified: /09/2023
 Acknowledgement:
 */

import SwiftUI

struct NoteListView: View {
    // Sample Notes Data
    //    @State private var notes = [
    //        Note(content: "First note", isSelected: false),
    //        Note(content: "Second note", isSelected: false),
    //        Note(content: "Third note", isSelected: false)
    //    ]
    @StateObject var viewModel = NoteListViewModel()
    
    @State var tempNote: NoteModel
    @State var noteStatus: NoteStatus = .none
    @State var prevStatus: NoteStatus = .none
    @State var showingAddNoteView = false
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach($viewModel.notes) { $note in
                    // Within the NoteListView's ForEach loop:
                    NavigationLink(destination:  NoteDetailView(note: $note, noteStatus: $noteStatus).navigationBarBackButtonHidden(true)) {
                        NoteRowView(noteContent: note.title)
                    }
                    
                    .swipeActions {
                        Button {
                            withAnimation {
                                if let index = viewModel.notes.firstIndex(of: note) {
                                    viewModel.notes.remove(at: index)
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
            .background(    // Invisible navigation link activated when the add note button is clicked
                    NavigationLink("", destination: NoteDetailView(note: $tempNote, noteStatus: $noteStatus).navigationBarBackButtonHidden(true), tag: 1, selection: $action)
                        .opacity(0) // Makes it invisible
                )
            .toolbar {
                Button {
                    tempNote = NoteModel(id: UUID(), title: "Untitled", dateCreated: Date(), body: "empty...")
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
            if prevStatus == .create && newStatus == .none {
                viewModel.notes.append(tempNote)
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
