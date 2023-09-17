//
//  MainView.swift
//  Dictionary23am
//
//  Created by ngminh on 15/09/2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Binding var isLoggedIn: Bool
    @State private var profileName: String = ""
    @State private var profileBio: String = ""
    
    var body: some View {
        VStack {
            Text("Profile!")
                .font(.largeTitle)
                .padding()

            Spacer()
            
            if let user = userVM.currentUser {
                Text("Name: \(user.username)")
                    .font(.title)
                    .padding()
                
                Text("Email: \(user.email)")
                    .padding()
                
                Text("Bio: \(user.bio)")
                    .padding()
                
                Text("ID: \(user.id)")
                    .padding()
            }

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
            .environmentObject(UserViewModel())
    }
}
