//
//  EditState.swift
//  Dictionary23am
//
//  Created by Tran Anh Hung on 16/09/2023.
//

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
