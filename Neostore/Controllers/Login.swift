//
//  Login.swift
//  Neostore
//
//  Created by Neosoft on 27/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//



import SwiftUI
import Combine

struct Login: View {
    
    @ObservedObject private var loginModel = LoginViewModel()
    @State var isShowing = false
    @Environment(\.presentationMode) var  presentationMode

    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .center){
                Color(UIColor.red)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing:30){
                    Text("NeoSTORE")
                        .padding(.top, 100)
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                    VStack{
                        AutoTextFields(name: self.$loginModel.email, icon: "username_icon", placeholder: "Username",erroMsg:self.loginModel.emailMessage,isSecure:false)
                        AutoTextFields(name: self.$loginModel.password, icon: "password_icon", placeholder: "Password",erroMsg:self.loginModel.passwordMessage,isSecure: true)
                        
                    }
                    VStack(spacing:15){
                        Button(action: {
                            print("Login")
                            self.loginModel.login()
                        }){
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.red)
                        }.disabled(!self.loginModel.isValid)
                            .frame(width: size.width-40, height: 45, alignment: .center)
                            .background(!self.loginModel.isValid ? Color.gray : Color.white)
                            .cornerRadius(8)
                        
                        Button(action: {
                            print("gdgg")
                        }){
                            Text("Forgot Password?")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    HStack{
                        Text("DO NOT HAVE AN ACCOUNT?")
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text("+")
                                .padding(.all, 10)
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }
                        
                    }
                    
                }
                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: self.$loginModel.isShowing, style: .large)
                }
                .frame(width: geometry.size.width / 2 - 20,
                       height: geometry.size.height / 5)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(self.loginModel.isShowing ? 1 : 0)
                
            }.alert(isPresented: self.$loginModel.showAlert){
                return Alert(title: Text(self.loginModel.errorOrSuceesMsg), dismissButton: .default(Text("OK")))
            }
            
        }
    }
}










struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
