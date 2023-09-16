//
//  NoteDetailView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 16/09/2023.
//

import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    
    var body: some View {
        VStack {
            TextEditor(text: $note.content)
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
    @State static var sampleNote = Note(content: "Sample Note Content", isSelected: false)
    
    static var previews: some View {
        NoteDetailView(note: $sampleNote)
    }
}


