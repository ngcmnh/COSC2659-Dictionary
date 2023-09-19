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
 https://github.com/rckim77/Sudoku
 https://developer.apple.com/design/human-interface-guidelines/typography
 */

import Foundation
import UIKit

protocol ViewModel {
    var isIpad: Bool { get }
    var isLargestIpad: Bool { get }
    var screenHeight: CGFloat { get }
    var screenWidth: CGFloat { get }
}

extension ViewModel {
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// E.g., 12.9-inch iPads
    var isLargestIpad: Bool {
        isIpad && screenWidth > 1023
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .body).withSize(UIFont.preferredFont(forTextStyle: .body).pointSize + 5)
        }
        return UIFont.preferredFont(forTextStyle: .body).withSize(UIFont.preferredFont(forTextStyle: .body).pointSize)
    }
    
    var footnote: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .footnote).withSize(UIFont.preferredFont(forTextStyle: .footnote).pointSize + 5)
        }
        return UIFont.preferredFont(forTextStyle: .footnote).withSize(UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }
    
    var largeTitle: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .largeTitle).withSize(UIFont.preferredFont(forTextStyle: .largeTitle).pointSize + 7)
        }
        return UIFont.preferredFont(forTextStyle: .largeTitle).withSize(UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
}
