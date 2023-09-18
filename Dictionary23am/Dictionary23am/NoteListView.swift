//
//  NoteListView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 15/09/2023.
//

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
    @State var showingAddNoteView = false
    @State private var action: Int? = 0
    
    var body: some View {
        NavigationView {
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
                                .foregroundColor(.white) // Text color
                                .padding(.horizontal, 10) // Add some padding around the text
                                .padding(.vertical, 5)
                                .background(Color.red) // Background color
                                .cornerRadius(5) // Optional: Round the corners of the button
                        }
                        .tint(.red)
                    }
                }
                Text("Number of Notes: \(viewModel.notes.count)") // This line displays the count of notes.
                    .padding(.top, 5)
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                NavigationLink(destination: NoteDetailView(note: $tempNote, noteStatus: $noteStatus).navigationBarBackButtonHidden(true), tag: 1, selection: $action) {}
            }
            .toolbar {
                Image(systemName: "plus")
                    .foregroundColor(Color("Primary"))
                    .onTapGesture {
                        noteStatus = .create
                        self.action = 1
                    }
            }
        }
        .onChange(of: noteStatus, perform: {
            viewModel.notes.append(tempNote)
        })
    }
}


struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(tempNote: NoteModel.sample, noteStatus: .none, showingAddNoteView: false)
    }
}
