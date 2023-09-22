//
//  EditProfileSheet.swift
//  Dictionary23am
//
//  Created by ngminh on 18/09/2023.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct EditProfileSheet: View {
    @EnvironmentObject var userVM: UserViewModel
    let viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var selectedImageUrl: String? = nil
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
//    @State private var imageUrls = [
//        "https://images.unsplash.com/photo-1501426026826-31c667bdf23d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2672&q=80",
//        "https://images.unsplash.com/photo-1462524500090-89443873e2b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
//        "https://images.unsplash.com/photo-1617959134699-1c49d9be59e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2748&q=80",
//        "https://images.unsplash.com/photo-1453235421161-e41b42ebba05?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2670&q=80",
//        "https://images.unsplash.com/photo-1522162363424-d29ded2ad958?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2748&q=80",
//        "https://images.unsplash.com/photo-1606214174585-fe31582dc6ee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2717&q=80",
//        "https://images.unsplash.com/photo-1543002588-bfa74002ed7e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2574&q=80",
//        "https://plus.unsplash.com/premium_photo-1661816797370-928a8749043c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2673&q=80"
//    ]
    
    var body: some View {
        NavigationView {
            VStack (spacing: 30) {
//                Section(header: Text("Choose Avatar")) {
//                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 35) {
//                        ForEach(imageUrls, id: \.self) { imageUrl in
//                            VStack {
//                                AsyncImage(url: URL(string: imageUrl), content: { image in
//                                    image
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fill)
//                                        .frame(width: 120, height: 120)
//                                        .cornerRadius(100)
//                                }, placeholder: {
//                                    Circle()
//                                        .foregroundColor(.gray)
//                                        .frame(width: 120, height: 120)
//                                })
//                                .overlay {
//                                    if selectedImageUrl == imageUrl {
//                                        Color(.black).opacity(0.3)
//                                            .frame(width: 120, height: 120)
//                                            .cornerRadius(100)
//                                        // Overlay checkmark if image is selected
//                                        Image(systemName: "checkmark")
//                                            .bold()
//                                            .foregroundColor(.white)
//                                            .opacity(1)
//                                    }
//                                }
//                            }
//                            .onTapGesture {
//                                selectedImageUrl = imageUrl
//                            }
//                        }
//                    }
//                }
                
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    VStack {
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: userVM.profilePicSize, height: userVM.profilePicSize)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        }
                        else {
                            Image("default-pfp")
                                .resizable()
                                .frame(width: userVM.profilePicSize, height: userVM.profilePicSize)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .overlay{
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.black, lineWidth: 3)
                    )
                }
                
//                Section(header: Text("Name")) {
//                    TextField("", text: $username)
//                        .autocorrectionDisabled()
//                }
//                .font(Font(userVM.body))
                TextField ("Name", text: $username)
                    .font(Font(userVM.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
//                Section(header: Text("bio")) {
//                    TextEditor(text: $bio)
//                }
//                .font(Font(userVM.body))
                
                TextField ("Bio", text: $bio)
                    .font(Font(userVM.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                Spacer()
                    .frame(height: viewModel.screenHeight/3)
            }
            .padding(.horizontal, viewModel.horizontalPadding)
            .onAppear {
                if let currentUser = userVM.currentUser {
                    self.username = currentUser.username ?? ""
                    self.bio = currentUser.bio ?? ""
                    self.selectedImageUrl = currentUser.imgUrl ?? ""
                }
                
                if self.image == nil, let imageUrl = self.selectedImageUrl {
                    fetchImage(from: imageUrl)
                }
            }
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                        username = ""
                        bio = ""
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Primary"))
                    }
                }

                ToolbarItem {
                    Button(action: {
                        saveProfileInfo()
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("Primary"))
                    }
                }
            })
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
    
    func saveProfileInfo() {
        if let _ = self.image {
            // If the user has selected a new image, we upload it to storage
            persistImageToStorage { imageUrl in
                if let imageUrl = imageUrl {
                    self.userVM.updateNameAndBio(imgUrl: imageUrl, username: self.username, bio: self.bio)
                }
            }
        } else {
            // If there's no new image selected, we just update the name and bio
            userVM.updateNameAndBio(imgUrl: selectedImageUrl!, username: username, bio: bio)
        }
    }
    
    func fetchImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
    
    private func persistImageToStorage(completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(uid).jpg")
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    completion(nil)
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {
                    completion(nil)
                    return
                }
                
                print("Successfully stored image with url: \(imageUrl)")
                print(imageUrl)
                
                completion(imageUrl)
            }
        }
    }
}

struct EditProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSheet()
            .environmentObject(UserViewModel())
    }
}
