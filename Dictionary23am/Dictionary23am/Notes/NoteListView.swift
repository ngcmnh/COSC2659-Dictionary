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
                ForEach(notes, id: \.id) { note in
                    // Within the NoteListView's ForEach loop:
                    NavigationLink(destination: NoteDetailView(note: $notes[notes.firstIndex(where: { $0.id == note.id })!])) {
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
                Text("Number of Notes: \(notes.count)") // This line displays the count of notes.
                               .padding(.top, 10)
                               .font(.footnote)
                               .foregroundColor(.gray)
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

