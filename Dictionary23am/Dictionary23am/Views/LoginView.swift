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
import LocalAuthentication

struct LoginView: View {
    @EnvironmentObject var userVM: UserViewModel
    @State private var navigateToSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword: Bool = false
    @State private var alreadyLoggedIn = false
    @State private var errorText = ""
    @State private var showForgotPasswordSheet = false
    @State private var isUserAuthenticated: Bool = (Auth.auth().currentUser != nil)

    let viewModel = LoginViewModel()
    
    var body: some View {
        if isUserAuthenticated {
            ContentView(isLoggedIn: $isUserAuthenticated)
        } else {
            content
        }
    }
    
    var content: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                NavigationLink("", destination: SignUpView(), isActive: $navigateToSignUp)
                    .opacity(0)
                
                Spacer()
                    .frame(height: viewModel.screenHeight/20)
                
                Text("Login")
                    .font(Font(viewModel.largeTitle))
                    .foregroundColor(Color("Primary"))
                    .padding(.vertical, 40)
                
                VStack (spacing: 20) {
                
                    TextField ("Email", text: $email)
                        .font(Font(viewModel.body))
                        .foregroundColor(Color("Text"))
                        .tint(Color("Tertiary"))
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.all, 8)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("Password", text: $password)
                                .font(Font(viewModel.body))
                                .foregroundColor(Color("Text"))
                                .tint(Color("Tertiary"))
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.all, 8)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                        } else {
                            SecureField("Password", text: $password)
                                .font(Font(viewModel.body))
                                .foregroundColor(Color("Text"))
                                .tint(Color("Tertiary"))
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.all, 8)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color("Text"))
                                .padding(.trailing, 8)
                        }
                    }
                    
                    Button("Forgot Password?") {
                        showForgotPasswordSheet = true
                    }
                    .font(Font(userVM.subHeadline))
                    .foregroundColor(Color("Primary"))
                    
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
                
                Button(action: authenticateWithBiometrics) {
                    Image(systemName: "faceid")
                        .foregroundColor(.primary)
                        .font(Font(viewModel.title3))
                }
                
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
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showForgotPasswordSheet) {
                ResetPasswordSheet()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func authenticateWithBiometrics() {
        authenticateUser { authenticated in
            if authenticated {
                // Retrieve the email, password, and userID from UserDefaults
                if let storedEmail = UserDefaults.standard.string(forKey: "lastLoggedInUserEmail"),
                   let storedPassword = UserDefaults.standard.string(forKey: "lastLoggedInUserPassword"),
                   let storedUserID = UserDefaults.standard.string(forKey: "lastLoggedInUserID") {

                    print("Successfully logged in with User ID: \(storedUserID)")

                    Auth.auth().signIn(withEmail: storedEmail, password: storedPassword) { result, error in
                        if let error = error {
                            print(error.localizedDescription)
                            self.errorText = error.localizedDescription
                        } else {
                            if let user = result?.user {
                                let userID = user.uid
                                print("Successfully logged in with User ID: \(userID)")
                                self.userVM.setUserDetails(userID: userID, email: storedEmail)
                                self.isUserAuthenticated = true
                            }
                        }
                    }

                } else {
                    print("No stored email or userID found.")
                    // Handle this error appropriately in your UI
                    //self.errorText = "Stored credentials not found."
                }
            } else {
                // Handle biometric authentication failure
            }
        }
    }
    
    func login() {
        self.errorText = ""
        
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
                    UserDefaults.standard.set(email, forKey: "lastLoggedInUserEmail")
                    UserDefaults.standard.set(password, forKey: "lastLoggedInUserPassword")
                    UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "lastLoggedInUserID")
                }
                self.isUserAuthenticated = true
            }
        }
    }
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to login into your account"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true)
                    } else {
                        print("Face ID/Touch ID error:", authenticationError?.localizedDescription ?? "Unknown error")
                        completion(false)
                    }
                }
            }
        } else {
            print("Face ID/Touch ID is not available:", error?.localizedDescription ?? "Unknown error")
            completion(false)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserViewModel())
    }
}
