/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Ngoc Minh
 ID: S3907086
 Created date: 10/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 https://developer.apple.com/design/human-interface-guidelines/text-fields
 */

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
                .frame(height: viewModel.screenHeight/10)
            
            Text("Sign Up")
                .font(Font(viewModel.largeTitle))
                .padding(.vertical, 40)
                .foregroundColor(Color("Primary"))
            
            VStack(spacing: 20) {
                TextField ("Email", text: $email)
                    .font(Font(viewModel.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                SecureField ("Password", text: $password)
                    .font(Font(viewModel.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                SecureField ("Reconfirm Password", text: $reconfirmPassword)
                    .font(Font(viewModel.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                Text(errorText)
                    .font(Font(viewModel.body))
                    .foregroundColor(.red)
            }
            .padding(.horizontal, viewModel.horizontalPadding)

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
        self.errorText = ""
        
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
