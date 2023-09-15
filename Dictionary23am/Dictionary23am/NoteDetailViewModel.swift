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

class NoteDetailViewModel : ViewModel {
    let maxChars : Int = 50
    
    // put request to save note
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 40
        } else {
            return 18
        }
    }
}
