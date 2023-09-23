/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Ngoc Minh
 ID: S3907086
 Created date: 09/09/2023
 Last modified: 23/09/2023
 Acknowledgement:
 
 */

import SwiftUI
import Firebase

@main
struct Dictionary23amApp: App {
    @StateObject private var userVM = UserViewModel()
    @StateObject private var notelistVM = NoteListViewModel()
    @AppStorage("isDark") var isDark = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(userVM)
                .environmentObject(notelistVM)
                .preferredColorScheme(isDark ? .dark: .light)
        }
    }
}
