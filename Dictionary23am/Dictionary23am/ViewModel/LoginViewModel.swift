/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Minh Anh
 ID: S3931980
 Created date: 19/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 */

import Foundation

class LoginViewModel : ViewModel {
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 250
        } else {
            return 50
        }
    }
}
