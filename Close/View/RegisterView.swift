import SwiftUI
import UIKit
import Firebase

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    func registerUser(email: String, password: String) {
        Task {
            do {
                try await Auth.auth().createUser(withEmail: email, password: password)
                print("User Registered")
            } catch {
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
        Button(action: {
            isImagePickerPresented.toggle()
        }) {
            Text("Choose Profile Picture")
                .foregroundColor(.white)
                .customHAlign(.center)
                .customFillView(.blue)
        }
        .padding(.top, 10)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerViewController(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
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
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var selectedProfileImage: UIImage? = nil
    @StateObject private var viewModel = RegisterViewModel() // Using @StateObject to manage the viewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's register an account!")
                .font(.largeTitle.bold())
                .customHAlign(.leading)
            
            Text("First time here?\nWelcome to Close!")
                .font(.title3)
                .customHAlign(.leading)
            
            VStack(spacing: 12) {
                TextField("Username", text: $userName)
                    .textContentType(.emailAddress)
                    .customBorder(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .customBorder(1, .gray.opacity(0.5))
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .customBorder(1, .gray.opacity(0.5))
                
                TextField("About You", text: $userBio, axis: .vertical)
                    .frame(minHeight: 100, alignment: .top)
                    .textContentType(.emailAddress)
                    .customBorder(1, .gray.opacity(0.5))
                
                TextField("Bio Link (Optional)", text: $userBioLink)
                    .textContentType(.emailAddress)
                    .customBorder(1, .gray.opacity(0.5))
                
                ImagePicker(selectedImage: $selectedProfileImage)
                
                Button(action: {
                    viewModel.registerUser(email: emailID, password: password)
                }) {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .customHAlign(.center)
                        .customFillView(.black)
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button("Login Now") {
                        // Handle the action to transition to the login view
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                }
                .font(.callout)
                .customVAlign(.bottom)
            }
        }
        .customVAlign(.top)
        .padding(15)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
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
    
    func customBorder(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    func customFillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}

