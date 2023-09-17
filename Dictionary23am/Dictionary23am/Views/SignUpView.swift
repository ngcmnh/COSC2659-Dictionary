//
//  SignUpView.swift
//  Dictionary23am
//
//  Created by ngminh on 10/09/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToLogin = false
    @State private var email = ""
    @State private var password = ""
    @State private var reconfirmPassword = ""
    @State private var errorText = ""
    @State private var alreadyLoggedIn = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                //.opacity(0)
            
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
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Already have an account? Login")
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .background(Color.gray)
        .navigationBarBackButtonHidden(true)
    }
    
    func signup() {
        if password != reconfirmPassword {
            handleSignupError("Confirm password does not match")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.handleSignupError(error.localizedDescription)
            }
            else if let user = authResult?.user {
                self.storeUserInFirestore(userID: user.uid)
            }
        }
    }

    func storeUserInFirestore(userID: String) {
        let userDocument: [String: Any] = [
            "id": userID,
            "email": email,
            "username": "",  // default empty for now
            "bio": ""  // default empty for now
        ]

        Firestore.firestore().collection("user").document(userID).setData(userDocument, merge: false) { error in
            if let error = error {
                print("Error writing user to Firestore: \(error)")
                print(userID)
            } else {
                print("User successfully written to Firestore!")
                self.navigateToLogin = true
            }
        }
    }

    func handleSignupError(_ message: String) {
        self.navigateToLogin = false
        print(message)
        errorText = message
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
