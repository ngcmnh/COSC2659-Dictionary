//
//  LoginView.swift
//  Dictionary23am
//
//  Created by ngminh on 15/09/2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var alreadyLoggedIn = false
    @State private var errorText = ""
    
    var body: some View {
        if alreadyLoggedIn {
            //direct to main view
            ContentView(isLoggedIn: $alreadyLoggedIn)
        }
        else {
            content
        }
    }
    
    var content: some View {
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
            
            Spacer()
            
            Button(action: {
                self.navigateToSignUp = true
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .background(Color.gray)
        .navigationBarBackButtonHidden(true)
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
                errorText = error!.localizedDescription
            } else {
                if let user = result?.user {
                    let userID = user.uid
                    print("Successfully registered with User ID: \(userID)")
                }
                self.alreadyLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
