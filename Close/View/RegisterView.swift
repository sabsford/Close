import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

struct User: Codable {
    var username: String
    var userBio: String
//    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
}

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var userProfilePicData: Data?
    @Published var selectedProfileImage: UIImage? = nil
    @State private var userName: String = ""
    @State private var userBio: String = ""
//    @State private var userBioLink: String = ""
    @State private var emailID: String = ""
    @State private var password: String = ""
    
    func registerUser(email: String, password: String) {
        Task {
            do {
                try await Auth.auth().createUser(withEmail: email, password: password)
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                guard let imageData = userProfilePicData else { return }
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                let user = User(username: userName, userBio: userBio, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
                do {
                    try await Firestore.firestore().collection("Users").document(userUID).setData(from: user)
                    print("Saved Successfully")
                } catch {
                    await setError(error: error)
                }
            } catch {
                try? await Auth.auth().currentUser?.delete()
                await setError(error: error)
            }
        }
    }
    
    func setError(error: Error) async {
        await MainActor.run {
            errorMessage = error.localizedDescription
            showError.toggle()
        }
    }
}

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                Text("Choose Profile Picture")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerViewController(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
            }
        }
    }
}

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update not needed
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerViewController
        
        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.isImagePickerPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }
}

struct RegisterView: View {
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var userName: String = ""
    @State private var userBio: String = ""
//    @State private var userBioLink: String = ""
    @State private var selectedProfileImage: UIImage? = nil
    @StateObject private var viewModel = RegisterViewModel()
    @Binding var createAccount: Bool
    
    var body: some View {
        VStack(spacing: 11) {
//            Image(uiImage: UIImage(named: "logo") ?? UIImage())
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxHeight: 115)
            Text("Let's register an account!")
                .font(.title2.bold())
                .customHAlign(.leading)
            
            Text("First time here?\nWelcome to Close!")
                .font(.title3)
                .customHAlign(.leading)
            
            ZStack {
                if let image = selectedProfileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.top, 10)
            
            ImagePicker(selectedImage: $selectedProfileImage)
                .padding(.top, 10)
            
            VStack(spacing: 12) {
                TextField("Username", text: $userName)
                    .textContentType(.emailAddress)
                    .padding(.top, 25)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                TextField("About You", text: $userBio)
                    .frame(minHeight: 100, alignment: .top)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
//                TextField("Bio Link (Optional)", text: $userBioLink)
//                    .padding(.vertical, 10)
//                    .background(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                    )
                
                Button(action: {
                    viewModel.registerUser(email: emailID, password: password)
                }) {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .customHAlign(.center)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedProfileImage != nil ? Color.black : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(userName.isEmpty || userBio.isEmpty || emailID.isEmpty || password.isEmpty || selectedProfileImage == nil)
                .padding(.top, 10)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        createAccount.toggle()
                    }) {
                        Text("Login Now")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    
//                    NavigationLink("Login Now", destination: LoginView())
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
                }
                .font(.callout)
                .customVAlign(.bottom)
            }
        }
        .customVAlign(.top)
        .padding(15)
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(createAccount: .constant(true))
    }
}

extension View {
    func customHAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func customVAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}
