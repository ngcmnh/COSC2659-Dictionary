//
//  EditProfileSheet.swift
//  Dictionary23am
//
//  Created by ngminh on 18/09/2023.
//

import SwiftUI

struct EditProfileSheet: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var selectedImageUrl: String? = nil
    @State private var imageUrls = [
        "https://images.foody.vn/res/g95/944014/prof/s360x270/foody-upload-api-foody-mobile-gfgfgfgf-190730093015.jpg",
        "https://images.foody.vn/res/g1/1362/prof/s576x330/foody-mobile-pho-hung-nguyen-trai-986-635810420871508422.jpg",
        "https://images.foody.vn/res/g11/105275/prof/s360x270/image-5855cf4d-230719143433.jpeg",
        "https://images.foody.vn/res/g5/47293/prof/s360x270/image-02e4e88c-221228093305.jpeg",
        "https://images.foody.vn/res/g98/979200/s360x270/foody-upload-api-foody-album-20507789_14565707877-191129141122.jpg",
        "https://images.foody.vn/res/g28/273807/prof/s360x270/foody-mobile-14ss-jpg-569-636088555223057387.jpg",
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Avatar")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 35) {
                        ForEach(imageUrls, id: \.self) { imageUrl in
                            VStack {
                                AsyncImage(url: URL(string: imageUrl), content: { image in
                                    image
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(100)
                                }, placeholder: {
                                    Circle().foregroundColor(.gray)
                                })
                                .overlay(
                                    // Overlay checkmark if image is selected
                                    Image(systemName: "checkmark")
                                        .opacity(selectedImageUrl == imageUrl ? 1 : 0)
                                        .foregroundColor(.white)
                                )
                            }
                            .onTapGesture {
                                selectedImageUrl = imageUrl
                            }
                        }
                    }
                }
                
                Section(header: Text("Name")) {
                    TextField("", text: $username)
                }
                
                Section(header: Text("bio")) {
                    TextEditor(text: $bio)
                }
            }
            .onAppear {
                if let currentUser = userVM.currentUser {
                    self.username = currentUser.username ?? ""
                    self.bio = currentUser.bio ?? ""
                    self.selectedImageUrl = currentUser.imgUrl ?? ""
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                        username = ""
                        bio = ""
                    }) {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem {
                    Button(action: {
                        saveProfileInfo()
                        dismiss()
                        username = ""
                        bio = ""
                    }) {
                        Image(systemName: "checkmark")
                    }
                    //.disabled(username.isEmpty || bio.isEmpty)
                }
            })
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    func saveProfileInfo() {
        userVM.updateNameAndBio(imgUrl: selectedImageUrl!, username: username, bio: bio)
    }
}

struct EditProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSheet()
            .environmentObject(UserViewModel())
    }
}
