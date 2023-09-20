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
    @State private var showEditSheet = false
    @State private var logoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile!")
                    .font(.largeTitle)
                    .padding()

                Spacer()
                
                if let user = userVM.currentUser {
                    AsyncImage(url: URL(string: user.imgUrl)) { image in
                       image
                           .resizable()
                           .frame(width: 120, height: 120)
                           .cornerRadius(100)
                   } placeholder: {
                       ProgressView()  // Loading icon
                   }
                    
                    Text("Name: \(user.username)")
                        .font(.title)
                        .padding()
                    
                    Text("Email: \(user.email)")
                        .padding()
                    
                    Text("Bio: \(user.bio)")
                        .padding()
                }
                
                Spacer()

                HStack {
                    Button {
                        logoutAlert = true
                    } label: {
                        Text("Logout")
                            .bold()
                            .frame(width: 140, height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Button {
                        showEditSheet = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showEditSheet) {
            EditProfileSheet()
        }
        .alert(isPresented: $logoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .cancel(),
                secondaryButton: .default(Text("Yes")) {
                    logout()
                }
            )
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
