//
//  ResetPasswordView.swift
//  Dictionary23am
//
//  Created by ngminh on 20/09/2023.
//

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
            //Form {
            VStack (spacing: 30) {
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
                    // login action
                    sendPasswordReset()
                    if passwordResetMessage.isEmpty {
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
            
            //}
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }

//                ToolbarItem {
//                    Button(action: {
//                        sendPasswordReset()
//                        if passwordResetMessage.isEmpty {
//                            dismiss()
//                        }
//                    }) {
//                        Image(systemName: "checkmark")
//                    }
//                    //.disabled(username.isEmpty || bio.isEmpty)
//                }
            })
            .navigationTitle("Password Reset")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .alert(isPresented: $showPasswordResetAlert) {
            Alert(title: Text("Password Reset"), message: Text(passwordResetMessage), dismissButton: .default(Text("OK")))
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

struct ResetPasswordSheet_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordSheet()
    }
}
