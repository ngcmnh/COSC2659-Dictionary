/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: 23AMDictionary
 ID: s3907086, s3904422, s3880604, s3904901, s3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 https://dictionaryapi.dev/
 https://gist.github.com/vikaskore/b8e68cb324da31121c8bc6a061e51612
 https://github.com/rckim77/Sudoku
 https://youtu.be/0ytO3wCRKZU?si=ZgDxBYqK_RAJ_pJ0
 https://www.appicon.co/#image-sets
 https://www.flaticon.com/free-icon/books_2704442?term=book&page=1&position=89&origin=tag&related_id=2704442
 https://youtu.be/vzQDKYIKEb8?si=ghJQlGU6RkVpWLv-
 https://stackoverflow.com/questions/69002861/controlling-size-of-texteditor-in-swiftui
 https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
 https://www.youtube.com/watch?v=6b2WAePdiqA
 https://www.youtube.com/watch?v=uqkUumqFiF8
 https://www.youtube.com/watch?v=UeOi5H3HJOE
 https://www.youtube.com/watch?v=8MLdq9kotII
 https://www.youtube.com/watch?v=uhTRQ4TWQ9g
 https://www.youtube.com/watch?v=FFWP7eXn0ck
 https://matteomanferdini.com/mvvm-pattern-ios-swift/
 https://developer.apple.com/design/human-interface-guidelines/typography#Specifications
 https://developer.apple.com/design/human-interface-guidelines/dark-mode
 https://developer.apple.com/design/human-interface-guidelines/layout
 https://developer.apple.com/design/human-interface-guidelines/text-fields
 https://developer.apple.com/design/human-interface-guidelines/navigation-bars
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
    
    // MARK: Font size changes according to device
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
    
    var subHeadline: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .subheadline).withSize(UIFont.preferredFont(forTextStyle: .subheadline).pointSize + 5)
        }
        return UIFont.preferredFont(forTextStyle: .subheadline).withSize(UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
    
    var title1: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .title1).withSize(UIFont.preferredFont(forTextStyle: .title1).pointSize + 4)
        }
        return UIFont.preferredFont(forTextStyle: .title1).withSize(UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }
    
    var title3: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .title3).withSize(UIFont.preferredFont(forTextStyle: .title3).pointSize + 5)
        }
        return UIFont.preferredFont(forTextStyle: .title3).withSize(UIFont.preferredFont(forTextStyle: .title3).pointSize)
    }
    
    var largeTitle: UIFont {
        if isIpad {
            return UIFont.preferredFont(forTextStyle: .largeTitle).withSize(UIFont.preferredFont(forTextStyle: .largeTitle).pointSize + 7)
        }
        return UIFont.preferredFont(forTextStyle: .largeTitle).withSize(UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }
}
