//
//  LoginView.swift
//  Dictionary23am
//
//  Created by ngminh on 15/09/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var navigateToSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var alreadyLoggedIn = false
    @State private var errorText = ""
    @State private var showPasswordResetAlert = false
    @State private var passwordResetMessage = ""
    @State private var isUserAuthenticated: Bool = (Auth.auth().currentUser != nil)
    
    var body: some View {
        if isUserAuthenticated {
            ContentView(isLoggedIn: $isUserAuthenticated)
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                NavigationLink("", destination: SignUpView(), isActive: $navigateToSignUp)
                    .opacity(0)
                
                Text("Login")
                    .font(.largeTitle)
                
                Spacer()
                
                TextField ("Email", text: $email)
                    .foregroundColor(.primary)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                
                SecureField ("Password", text: $password)
                    .foregroundColor(.primary)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 30)
                
                Text(errorText)
                    .font(.title3)
                
                Button {
                    // login action
                   login()
                } label: {
                    Text("Login")
                        .bold()
                        .frame(width: 140, height:40)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                Button("Forgot Password?") {
                    sendPasswordReset()
                }
                .foregroundColor(.white)

                
                //Spacer()
                
                Button(action: {
                    self.navigateToSignUp = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .background(Color.gray)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showPasswordResetAlert) {
                Alert(title: Text("Password Reset"), message: Text(passwordResetMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                errorText = error.localizedDescription
            }
            else {
                if let user = result?.user {
                    let userID = user.uid
                    print("Successfully logged in with User ID: \(userID)")
                    self.userVM.setUserDetails(userID: userID, email: email)
                    
                }
                self.isUserAuthenticated = true
            }
        }
    }
    
    func sendPasswordReset() {
        guard !email.isEmpty else {
            passwordResetMessage = "Please enter your email address."
            showPasswordResetAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                passwordResetMessage = "Error: \(error.localizedDescription)"
            } else {
                passwordResetMessage = "A password reset link has been sent to your email address."
            }
            showPasswordResetAlert = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserViewModel())
    }
}
