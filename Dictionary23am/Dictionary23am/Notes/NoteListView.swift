//
//  NoteListView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 15/09/2023.
//

import SwiftUI

struct NoteListView: View {
    // Sample Notes Data
    @State private var notes = [
        Note(content: "First note", isSelected: false),
        Note(content: "Second note", isSelected: false),
        Note(content: "Third note", isSelected: false)
    ]
    
    @State private var showingAddNoteView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.content) { note in
                    NavigationLink(destination: NoteDetailView(noteContent: note.content)) {
                        NoteRowView(isDone: $notes[notes.firstIndex(where: { $0.content == note.content })!].isSelected, noteContent: note.content)
                    }
                        .swipeActions {
                            Button {
                                withAnimation {
                                    if let index = notes.firstIndex(where: { $0.content == note.content }) {
                                        notes.remove(at: index)
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
            }
            .sheet(isPresented: $showingAddNoteView) {
                AddNoteView(notes: $notes)
            }
            .toolbar {
                Button {
                    showingAddNoteView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationBarTitle("Notes List")
        }
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}

