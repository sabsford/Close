//
//  RegisterView.swift
//  Close
//
//  Created by SF on 8/8/23.
//

import SwiftUI
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

struct RegisterView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @StateObject private var viewModel = RegisterViewModel() // Using @StateObject to manage the viewModel
    
    var body: some View{
        VStack(spacing: 10){
            Text("Lets register account!")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("First time here?,\nWelcome to Close!")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 12){
                TextField("Username", text: $userName)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("About You", text: $userBio,axis: .vertical)
                    .frame(minHeight: 100,alignment: .top)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                TextField("Bio Link (Optional)", text: $userBioLink)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))

                Button {
                    viewModel.registerUser(email: emailID, password: password) // Using viewModel's function
                } label: {
                    //MARK: Sign Up Button
                    Text("Sign up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
                
                HStack{
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button("Login Now"){
                        // Implement the login action here
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                }
                .font(.callout)
                .vAlign(.bottom)
            }
        }
        .vAlign(.top)
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

// MARK: view eXTENSIONS FOR UI building
extension View{
    func customHAlign(_ alignment: Alignment)-> some View{
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func customVAlign(_ alignment: Alignment)-> some View{
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    //MARK: Custom Border View with Padding
    func customBorder(_ width: CGFloat, _ color: Color)-> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    //MARK: Custom Fill View with Padding
    func customFillView(_ color: Color)-> some View{
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
