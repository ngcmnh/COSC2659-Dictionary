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
                            // Light/Dark mode button
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
                            .alert(isPresented: $showAlert) {  // Alert to confirm logging out
                                Alert(title: Text("Confirm Logout"), message: Text("Are your sure you want to log out?"), primaryButton: .destructive(Text("Yes")) {logout()}, secondaryButton: .cancel())
                            }
                        }
                        
                        Spacer()
                        
                        // Profile image
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
                            Image("default-pfp")  // Default image if no image is displayed
                                .resizable()
                                .frame(width: userVM.profilePicSize, height: userVM.profilePicSize)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        }
                        
                        // Username field
                        Text(!user.username.isEmpty ? "\(user.username)" : "Username")
                            .font(Font(userVM.title1))
                            .foregroundColor(Color("Text"))
                        
                        HStack {
                            Spacer()
                            Button {   // Button to show edit profile sheet
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
                        // Bio display fields
                        VStack (alignment: .leading){
                            Text("Bio")
                                .font(Font(userVM.body))
                                .bold()
                            Text("\(user.bio)")
                                .font(Font(userVM.body))
                        }
                        .padding(.vertical, userVM.verticalPadding)
                        
                        Divider()
                        
                        // Email display fields
                        VStack (alignment: .leading) {
                            Text("Email")
                                .font(Font(userVM.body))
                                .bold()
                            Text("\(user.email)")
                                .font(Font(userVM.body))
                        }
                        .padding(.vertical, userVM.verticalPadding)
                    }
                    .padding(.horizontal, userVM.horizontalPadding)
                    .frame(width: userVM.screenWidth)
                }
                
                Spacer()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showEditSheet) { // Show edit sheet
            EditProfileSheet()
        }
    }
    
    // Logout function via authentication
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
