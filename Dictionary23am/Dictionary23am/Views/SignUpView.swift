/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: 23AMDictionary
 ID: s3907086, s3904422, s3880604, s3904901, s3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 https://dictionaryapi.dev/
 https://gist.github.com/vikaskore/b8e68cb324da31121c8bc6a061e51612
 https://github.com/rckim77/Sudoku
 https://youtu.be/0ytO3wCRKZU?si=ZgDxBYqK_RAJ_pJ0
 https://www.appicon.co/#image-sets
 https://www.flaticon.com/free-icon/books_2704442?term=book&page=1&position=89&origin=tag&related_id=2704442
 https://youtu.be/vzQDKYIKEb8?si=ghJQlGU6RkVpWLv-
 https://stackoverflow.com/questions/69002861/controlling-size-of-texteditor-in-swiftui
 https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
 https://www.youtube.com/watch?v=6b2WAePdiqA
 https://www.youtube.com/watch?v=uqkUumqFiF8
 https://www.youtube.com/watch?v=UeOi5H3HJOE
 https://www.youtube.com/watch?v=8MLdq9kotII
 https://www.youtube.com/watch?v=uhTRQ4TWQ9g
 https://www.youtube.com/watch?v=FFWP7eXn0ck
 https://matteomanferdini.com/mvvm-pattern-ios-swift/
 https://developer.apple.com/design/human-interface-guidelines/typography#Specifications
 https://developer.apple.com/design/human-interface-guidelines/dark-mode
 https://developer.apple.com/design/human-interface-guidelines/layout
 https://developer.apple.com/design/human-interface-guidelines/text-fields
 https://developer.apple.com/design/human-interface-guidelines/navigation-bars
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
            // MARK: -Sign Up fields
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
                // Sign up function
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
                self.presentationMode.wrappedValue.dismiss()  //  Dismiss the signup view
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
    
    // Sign up function to create user through Firebase Authentication
    func signup() {
        if password != reconfirmPassword {  // Check for match password fields
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
    
    // Store new user to Firestore
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
