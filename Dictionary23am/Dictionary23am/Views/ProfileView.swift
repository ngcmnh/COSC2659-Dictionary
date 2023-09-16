//
//  MainView.swift
//  Dictionary23am
//
//  Created by ngminh on 15/09/2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .padding()

            Spacer()

            Button {
                logout()
            } label: {
                Text("Logout")
                    .bold()
                    .frame(width: 140, height: 40)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
    
    func logout() {
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
            } catch {
                print("Failed to sign out: \(error.localizedDescription)")
            }
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
    }
}
