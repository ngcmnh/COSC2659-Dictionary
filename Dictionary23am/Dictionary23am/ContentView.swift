//
//  ContentView.swift
//  Dictionary23am
//
//  Created by ngminh on 09/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NoteListView(tempNote: NoteModel.sample, noteStatus: .none, showingAddNoteView: false)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
