//
//  ContentView.swift
//  Dictionary23am
//
//  Created by ngminh on 09/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(), note: .constant(NoteModel.sample)).navigationBarBackButtonHidden(true)) {
                Image(systemName: "note.text")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
