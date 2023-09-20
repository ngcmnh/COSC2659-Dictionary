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
//    @State private var navigateToProfile = false
    @State private var selectedImageUrl: String? = nil
    @State private var imageUrls = [
        "https://images.unsplash.com/photo-1501426026826-31c667bdf23d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2672&q=80",
        "https://images.unsplash.com/photo-1462524500090-89443873e2b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
        "https://images.unsplash.com/photo-1617959134699-1c49d9be59e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2748&q=80",
        "https://images.unsplash.com/photo-1453235421161-e41b42ebba05?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
        "https://images.unsplash.com/photo-1522162363424-d29ded2ad958?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2748&q=80",
        "https://images.unsplash.com/photo-1606214174585-fe31582dc6ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2717&q=80"
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
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(100)
                                }, placeholder: {
                                    Circle()
                                        .foregroundColor(.gray)
                                        .frame(width: 120, height: 120)
                                })
                                .overlay {
                                    if selectedImageUrl == imageUrl {
                                        Color(.black).opacity(0.3)
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(100)
                                        // Overlay checkmark if image is selected
                                        Image(systemName: "checkmark")
                                            .bold()
                                            .foregroundColor(.white)
                                            .opacity(1)
                                    }
                                }
                            }
                            .onTapGesture {
                                selectedImageUrl = imageUrl
                            }
                        }
                    }
                }
                
                Section(header: Text("Name")) {
                    TextField("", text: $username)
                        .autocorrectionDisabled()
                }
                .font(Font(userVM.body))
                
                Section(header: Text("bio")) {
                    TextEditor(text: $bio)
                }
                .font(Font(userVM.body))
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        username = ""
                        bio = ""
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Primary"))
                    }
                }

                ToolbarItem {
                    Button(action: {
                        saveProfileInfo()
                        username = ""
                        bio = ""
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("Primary"))
                    }
                    .disabled(username.isEmpty || bio.isEmpty)
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
