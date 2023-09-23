/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Ngoc Minh
 ID: S3907086
 Created date: 15/09/2023
 Last modified: 23/09/2023
 Acknowledgement:
 https://developer.apple.com/design/human-interface-guidelines/dark-mode
 https://developer.apple.com/design/human-interface-guidelines/layout
 */

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Binding var isLoggedIn: Bool
    @AppStorage("isDark") private var isDark = false
    @State private var profileName: String = ""
    @State private var profileBio: String = ""
    @State private var showEditSheet = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                if let user = userVM.currentUser {
                    VStack {
                        HStack {
                            Button (action: {
                                isDark.toggle()
                            }, label: {
                                VStack {
                                    Image(systemName: isDark ? "moon" : "sun.max")
                                        .font(Font(userVM.body))
                                    Spacer().frame(height: 2)
                                }
                            })
                            .foregroundColor(Color("Primary"))
                            .preferredColorScheme(isDark ? .dark : .light)
                            .padding(.top, 10)
                            .padding(.leading, 18)
                            
                            Spacer()

                            Button {
                                showAlert = true
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                            }
                            .font(Font(userVM.body))
                            .foregroundColor(Color("Primary"))
                            .padding(.trailing, 18)
                            .padding(.top, 10)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Confirm Logout"), message: Text("Are your sure you want to log out?"), primaryButton: .destructive(Text("Yes")) {logout()}, secondaryButton: .cancel())
                            }
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: user.imgUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: userVM.profilePicSize, height: userVM.profilePicSize)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        } placeholder: {
                            Image("default-pfp")
                                .resizable()
                                .frame(width: userVM.profilePicSize, height: userVM.profilePicSize)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        }
                        
                        Text(!user.username.isEmpty ? "\(user.username)" : "Username")
                            .font(Font(userVM.title1))
                            .foregroundColor(Color("Text"))
                        
                        HStack {
                            Spacer()
                            Button {
                                showEditSheet = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .font(Font(userVM.body))
                            }
                            .foregroundColor(Color("Primary"))
                            .padding(.trailing, 18)
                            .padding(.bottom, 10)
                        }
                    }
                    .frame(width: userVM.screenWidth, height: userVM.screenHeight / 3)
                    .background(Color("GrayBackground"))
                    
                    VStack (alignment: .leading){
                        VStack (alignment: .leading){
                            Text("Bio")
                                .font(Font(userVM.body))
                                .bold()
                            Text("\(user.bio)")
                                .font(Font(userVM.body))
                        }
//                        .frame(width: userVM.screenWidth)
                        .padding(.vertical, userVM.verticalPadding)
                        
                        Divider()
                        
                        VStack (alignment: .leading) {
                            Text("Email")
                                .font(Font(userVM.body))
                                .bold()
                            Text("\(user.email)")
                                .font(Font(userVM.body))
                        }
//                        .frame(width: userVM.screenWidth)
                        .padding(.vertical, userVM.verticalPadding)
                    }
                    .padding(.horizontal, userVM.horizontalPadding)
                    .frame(width: userVM.screenWidth)
                }
                
                Spacer()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showEditSheet) {
            EditProfileSheet()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
            .environmentObject(UserViewModel())
    }
}
