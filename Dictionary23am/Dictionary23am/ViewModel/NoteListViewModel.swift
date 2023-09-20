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

import Foundation

class NoteListViewModel: ObservableObject, ViewModel {
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
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 20
        } else {
            return 10
        }
    }
    
    var verticalPadding: CGFloat {
        if isIpad {
            return 10
        } else {
            return 5
        }
    }
}
