//
//  ResetPasswordView.swift
//  Dictionary23am
//
//  Created by ngminh on 20/09/2023.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var showPasswordResetAlert = false
    @State private var passwordResetMessage = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            //Form {
                VStack {
                    TextField ("Email", text: $email)
                        .foregroundColor(.primary)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 30)
                }
            //}
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem {
                    Button(action: {
                        sendPasswordReset()
                        if passwordResetMessage.isEmpty {
                            dismiss()
                        }
                    }) {
                        Image(systemName: "checkmark")
                    }
                    //.disabled(username.isEmpty || bio.isEmpty)
                }
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

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
