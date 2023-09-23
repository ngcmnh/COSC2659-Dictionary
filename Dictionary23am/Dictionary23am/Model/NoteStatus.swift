/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Minh Anh
 ID: S3931980
 Created date: 16/09/2023
 Last modified: 16/09/2023
 Acknowledgement:
 
 */

import Foundation

enum NoteStatus : Equatable {
    case none
    case create
    case update
    
    var rawValue: String {
            switch self {
            case .none: return "none"
            case .create: return "create"
            case .update: return "update"
            }
        }
}
