//
//  MainView.swift
//  Dictionary23am
//
//  Created by ngminh on 15/09/2023.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Binding var isLoggedIn: Bool
    @State private var profileName: String = ""
    @State private var profileBio: String = ""
    @State private var showEditSheet = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                if let user = userVM.currentUser {
                    VStack {
                        Spacer()
                        
                        AsyncImage(url: URL(string: user.imgUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: userVM.screenWidth/5*2, height: userVM.screenWidth/5*2)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        } placeholder: {
                            Image("default-pfp")
                                .resizable()
                                .frame(width: userVM.screenWidth/5*2, height: userVM.screenWidth/5*2)
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
                
                HStack {
                    Spacer()
                    
                    Button {
                        logout()
                    } label: {
                        Text("Logout")
                            .font(Font(userVM.body))
                            .bold()
                    }
                    .buttonStyle(.borderless)
                    .padding(.all, 10)
                    .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(.bottom, 85)
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
