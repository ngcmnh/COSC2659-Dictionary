/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Minh Anh
 ID: S3931980
 Created date: 14/09/2023
 Last modified: /09/2023
 Acknowledgement:
 https://matteomanferdini.com/mvvm-pattern-ios-swift/
 */

import Foundation
import Firebase

class NoteDetailViewModel : ViewModel {
    let maxChars : Int = 50
            
    // request to save note
    func createNote(note: NoteModel) {
        print("Creating Note")
        print(note)
    }
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 40
        } else {
            return 18
        }
    }
    
    var spacing: CGFloat {
        if isIpad {
            return 30
        } else {
            return 15
        }
    }
}
