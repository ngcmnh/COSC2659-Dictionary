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
    
    let viewModel = LoginViewModel()
    
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
        NavigationView {
            VStack(spacing: 30) {
                
                NavigationLink("", destination: SignUpView(), isActive: $navigateToSignUp)
                    .opacity(0)
                
                Spacer()
                    .frame(height: viewModel.screenHeight/6)
                
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(Color("Primary"))
                
                TextField ("Email", text: $email)
                    .foregroundColor(Color("Text"))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, viewModel.horizontalPadding)
                
                SecureField ("Password", text: $password)
                    .foregroundColor(Color("Text"))
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, viewModel.horizontalPadding)
                
                Text(errorText)
                    .font(.title3)
                    .foregroundColor(.red)
                
                Button {
                    // login action
                    login()
                } label: {
                    Text("Login")
                        .bold()
                        .foregroundColor(Color("TextOnPrimary"))
                        .frame(width: 140, height:40)
                        .background(Color("Primary"))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    self.navigateToSignUp = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(Color("Text"))
                }
                
                Spacer()
            }
            .background(Color("Background"))
            .navigationBarBackButtonHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                self.alreadyLoggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserViewModel())
    }
}
