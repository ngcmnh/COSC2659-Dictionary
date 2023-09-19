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
                    .font(Font(viewModel.largeTitle))
                    .foregroundColor(Color("Primary"))
                    .padding(.vertical, 40)
                
                VStack {
                    
                    TextField ("Email", text: $email)
                        .font(Font(viewModel.body))
                        .foregroundColor(Color("Text"))
                        .tint(Color("Tertiary"))
                        .textContentType(.emailAddress)
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
                    
                    Text(errorText)
                        .font(Font(viewModel.body))
                        .foregroundColor(.red)
                }
                .padding(.horizontal, viewModel.horizontalPadding)
                
                Button {
                    // login action
                    login()
                } label: {
                    Text("Login")
                        .font(Font(viewModel.footnote))
                        .bold()
                        .foregroundColor(Color("TextOnPrimary"))
                        .frame(width: 140, height:40)
                        .background(Color("Primary"))
                        .cornerRadius(10)
                }
                .padding(.bottom, 70)
                
                Button(action: {
                    print("In Login, navigate to sign up? \(navigateToSignUp)")
                    self.navigateToSignUp = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .font(Font(viewModel.body))
                        .foregroundColor(Color("Text"))
                }
                
                Spacer()
            }
//            .background(Color("Background"))
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
