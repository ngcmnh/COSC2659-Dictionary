//
//  Dictionary23amApp.swift
//  Dictionary23am
//
//  Created by ngminh on 09/09/2023.
//

import SwiftUI
import Firebase

@main
struct Dictionary23amApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
