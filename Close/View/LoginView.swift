//
//  LoginView.swift
//  Close
//
//  Created by SF on 8/7/23.
//

import SwiftUI

struct LoginView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    //MARK: View Properties
    @State var createAccount: Bool = false
    var body: some View {
        VStack(spacing: 10){
            Text("Lets sign you in!")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back,\nYou have been missed")
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
                
                Button("Reset password?", action: {})
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button {
                    
                } label: {
                    //MARK: Login Button
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
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
            RegisterView()
        }
    }
}

//MARK: Register View

struct RegisterView: View{
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    var body: some View{
        VStack(spacing: 10){
            Text("Lets sign you in!")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome Back,\nYou have been missed")
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

                
                Button {
                    
                } label: {
                    //MARK: Sign Up Button
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
                
                //MARK: Register button
                HStack{
                    Text("Already Have an account?")
                        .foregroundColor(.gray)
                    
                    Button("Login Now"){
                        
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// MARK: vIWQ eXTENSIONS FOR UI building
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
