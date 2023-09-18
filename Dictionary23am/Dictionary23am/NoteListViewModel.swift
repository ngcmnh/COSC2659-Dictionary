//
//  NoteListViewModel.swift
//  Dictionary23am
//
//  Created by Tran Anh Hung on 17/09/2023.
//

import Foundation

class NoteListViewModel: ObservableObject {
    @Published var notes: [NoteModel] = []

    init() {
        notes = getNoteList()
    }
    
    
    func getNoteList() -> [NoteModel] {
        // API request here
        // ...
        var result : [NoteModel] = []
        result.append(NoteModel(id: UUID(), title: "Note 1", dateCreated: Date(), body: "Some notes ..."))
        result.append(NoteModel(id: UUID(), title: "Note 2", dateCreated: Date(), body: "Some more notes ..."))
        return result
    }
}
