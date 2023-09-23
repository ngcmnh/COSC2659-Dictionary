/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Phan Nhat Minh
 ID: S3904422
 Created date: 18/09/2023
 Last modified: 23/09/2023
 Acknowledgement:
 https://www.youtube.com/watch?v=6b2WAePdiqA
 https://www.youtube.com/watch?v=UeOi5H3HJOE
 https://www.youtube.com/watch?v=FFWP7eXn0ck
 */

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
    
    var body: some View {
        NavigationView {
            VStack (spacing: 30) {
                // MARK: Profile image
                ZStack(alignment: .trailing) {
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
                    
                    Button {
                         shouldShowImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo.circle.fill")
                            .foregroundColor(Color("Primary"))
                            .font(Font(viewModel.title1))
                            .background(Circle().foregroundColor(Color("Background")))
                    }
                    .offset(x: -10, y: userVM.profilePicSize/3)
                }
                
                // MARK: Name text field
                TextField ("Name", text: $username)
                    .font(Font(userVM.body))
                    .foregroundColor(Color("Text"))
                    .tint(Color("Tertiary"))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.all, 8)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
                
                // MARK: Bio text field
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
                // Fill in text fields
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
