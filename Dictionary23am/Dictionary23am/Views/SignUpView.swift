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
    @State private var email = ""
    @State private var password = ""
    @State private var reconfirmPassword = ""
    @State private var errorText = ""
    @State private var alreadyLoggedIn = false
    
    let viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
                .frame(height: viewModel.screenHeight/6)
            
            Text("Sign Up")
                .font(Font(viewModel.largeTitle))
                .padding(.vertical, 40)
                .foregroundColor(Color("Primary"))
            
            TextField ("Email", text: $email)
                .font(Font(viewModel.body))
                .foregroundColor(Color("Text"))
                .tint(Color("Tertiary"))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, viewModel.horizontalPadding)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
            
            SecureField ("Password", text: $password)
                .font(Font(viewModel.body))
                .foregroundColor(Color("Text"))
                .tint(Color("Tertiary"))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, viewModel.horizontalPadding)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
            
            SecureField ("Reconfirm Password", text: $reconfirmPassword)
                .font(Font(viewModel.body))
                .foregroundColor(Color("Text"))
                .tint(Color("Tertiary"))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, viewModel.horizontalPadding)
                .textContentType(.password)
                .textInputAutocapitalization(.never)
            
            Text(errorText)
                .font(Font(viewModel.body))
                .foregroundColor(.red)
            
            Button {
                // sign up
                signup()
            } label: {
                Text("Sign Up")
                    .font(Font(viewModel.body))
                    .bold()
                    .frame(width: 140, height:40)
                    .background(Color("Primary"))
                    .cornerRadius(10)
                    .foregroundColor(Color("TextOnPrimary"))
            }
            .padding(.bottom, 70)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Already have an account? Login")
                    .font(Font(viewModel.body))
                    .foregroundColor(Color("Text"))
            }
            
            Spacer()
        }
        .background(Color("Background"))
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
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func handleSignupError(_ message: String) {
        print(message)
        errorText = message
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
