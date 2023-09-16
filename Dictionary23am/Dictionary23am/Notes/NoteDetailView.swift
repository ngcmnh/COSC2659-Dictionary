//
//  NoteDetailView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 16/09/2023.
//

import SwiftUI

struct NoteDetailView: View {
    @State private var editableNoteContent: String
    
    init(noteContent: String) {
        _editableNoteContent = State(initialValue: noteContent)
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $editableNoteContent)
                .padding()
                .background(Color(white: 0.95)) // Light gray background
                .cornerRadius(8) // Rounded corners
                .padding()
                .frame(minHeight: UIScreen.main.bounds.height * 0.8) // Making the height approximately 80% of the screen height
        }
        .navigationBarTitle("Note", displayMode: .inline)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(noteContent: "Sample Note Content")
    }
}


