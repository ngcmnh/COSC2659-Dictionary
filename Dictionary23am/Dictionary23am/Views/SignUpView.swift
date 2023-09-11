//
//  SignUpView.swift
//  Dictionary23am
//
//  Created by ngminh on 10/09/2023.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            TextField ("Email", text: $email)
                .foregroundColor(.primary)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            
            TextField ("Password", text: $password)
                .foregroundColor(.primary)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            
            Spacer()
            
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
            
            Button {
                // log in
                login()
            } label: {
                Text("Log In")
                    .bold()
                    .frame(width: 140, height:40)
                    .background(Color.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .background(Color.black)
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func signup() {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
