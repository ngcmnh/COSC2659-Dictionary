//
//  SignUpView.swift
//  Dictionary23am
//
//  Created by ngminh on 10/09/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var navigateToLogin = false
    @State private var email = ""
    @State private var password = ""
    @State private var reconfirmPassword = ""
    @State private var errorText = ""
    @State private var alreadyLoggedIn = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                    .opacity(0)
                
                Text("Sign Up")
                    .font(.largeTitle)
                    .padding(.vertical, 40)
                
                //Spacer()
                
                TextField ("Email", text: $email)
                    .foregroundColor(.primary)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                
                SecureField ("Password", text: $password)
                    .foregroundColor(.primary)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                
                SecureField ("Reconfirm Password", text: $reconfirmPassword)
                    .foregroundColor(.primary)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                
                Text(errorText)
                    .font(.title3)
                
                Button {
                    // sign up
                    signup()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 140, height:40)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    self.navigateToLogin = true
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .background(Color.gray)
        }
    }
    
    func signup() {
        // Check password confirmation before attempting to sign up
        if password != reconfirmPassword {
            self.navigateToLogin = false
            errorText = "Confirm password does not match"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                self.navigateToLogin = false
                print(error!.localizedDescription)
                errorText = error!.localizedDescription
            } else {
                self.navigateToLogin = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
