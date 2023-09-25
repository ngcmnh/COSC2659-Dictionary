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

struct ResetPasswordSheet: View {
    @State private var email = ""
    @State private var showPasswordResetAlert = false
    @State private var passwordResetMessage = ""
    @Environment(\.dismiss) var dismiss
    
    let viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack (spacing: 30) {
                
                // Field to enter email
                TextField ("Email", text: $email)
                    .font(Font(viewModel.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                    
                Button {
                    // send password reset mail function
                    sendPasswordReset()
                    if passwordResetMessage.isEmpty {  // No error then dismiss the sheet
                        dismiss()
                    }
                } label: {
                    Text("Send Reset Link")
                        .font(Font(viewModel.footnote))
                        .bold()
                        .foregroundColor(Color("TextOnPrimary"))
                        .frame(width: 140, height:40)
                        .background(Color("Primary"))
                        .cornerRadius(10)
                }
                .padding(.bottom, 70)
            }
            .padding(.horizontal, viewModel.horizontalPadding)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark") // Xmark
                    }
                }
            })
            .navigationTitle("Password Reset")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .alert(isPresented: $showPasswordResetAlert) { // Alert if there are any error
            Alert(title: Text("Password Reset"), message: Text(passwordResetMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Send password reset function via firebase authentication
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

struct ResetPasswordSheet_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordSheet()
    }
}
