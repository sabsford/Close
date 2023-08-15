import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var userLogin: String = ""
    
    func loginUser(email: String, password: String) {
        Task {
            if email.isEmpty || password.isEmpty {
                setError(message: "Please input valid email and password.")
                return
            }
            
            do {
                try await Auth.auth().signIn(withEmail: email, password: password)
                print("User Found")
                self.userLogin = email
                print(self.userLogin)
            } catch {
                await setError(error: error)
            }
        }
    }

    func resetPassword(email: String) {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Link Sent")
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
    
    func setError(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showError.toggle()
        }
    }
}

struct LoginView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    //MARK: View Properties
    @State var createAccount: Bool = false
    @StateObject private var viewModel = LoginViewModel() // Using @StateObject to manage the viewModel
    
    var body: some View {
        if viewModel.userLogin == "" {
            VStack(spacing: 10){
                Image(uiImage: UIImage(named: "logo") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 130)
                Text("Lets sign you in!")
                    .font(.largeTitle.bold())
                    .hAlign(.leading)
                
                Text("Welcome back,\nYou have been missed!")
                    .font(.title3)
                    .hAlign(.leading)
                
                VStack(spacing: 12){
                    TextField("Email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                    
                    Button(action: {
                        viewModel.resetPassword(email: emailID) // Using viewModel's function
                    }) {
                        Text("Reset password?")
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                    .hAlign(.trailing)
                    
                    Button(action: {
                        viewModel.loginUser(email: emailID, password: password) // Using viewModel's function
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .fillView(.black)
                    
                        

                    }
                    .padding(.top,10)
                    .alert(isPresented: $viewModel.showError) {
                        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    //MARK: Register button
                    HStack{
                        Text("Don't Have an account?")
                            .foregroundColor(.gray)
                        
                        Button("Register Now"){
                            createAccount.toggle()
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
            //MARK: Register View VIA SHeets
            .fullScreenCover(isPresented: $createAccount) {
                RegisterView(createAccount: $createAccount)
            }
        }else{
            NavigationView {
                HomePageSwift()
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: view eXTENSIONS FOR UI building
extension View{
    func hAlign(_ alignment: Alignment)-> some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    func vAlign(_ alignment: Alignment)-> some View{
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //MARK: Custom Border View with Padding
    func border(_ width: CGFloat,_ color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    //MARK: Custom Fill View with Padding
    func fillView(_ color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}

