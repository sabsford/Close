//
//  RegisterView.swift
//  Close
//
//  Created by SF on 8/8/23.
//

import SwiftUI

struct RegisterView: View{
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //MARK view properties
    @Environment(\.dismiss) var dismiss
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
                    
                } label: {
                    //MARK: Sign Up Button
                    Text("Sign up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,10)
                
                //MARK: Register button
                HStack{
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    
                    Button("Login Now"){
                        dismiss()
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
