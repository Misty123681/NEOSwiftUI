//
//  Registration.swift
//  Neostore
//
//  Created by Neosoft on 27/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import SwiftUI
import UIKit




struct Registration: View {
    
    @ObservedObject private var reg = RegistrationViewModel()
    @State var value : CGFloat = 0
    @State var push = false
    
    var body: some View {
        GeometryReader {geometry in
            ZStack(alignment:.center){
                Color(UIColor.red)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing:30){
                        Text("NeoSTORE")
                            .padding(.top, 70)
                            .foregroundColor(Color.white)
                            .font(.largeTitle)
                        VStack{
                            AutoTextFields(name: self.$reg.firstName, icon: "username_icon", placeholder: "First name",erroMsg:self.reg.firstMessage)
                            
                            AutoTextFields(name: self.$reg.lastName,icon: "username_icon", placeholder: "Last name",erroMsg:self.reg.lastMessage)
                            
                            
                            AutoTextFields(name: self.$reg.email,icon: "email_icon", placeholder: "Email",erroMsg:self.reg.emailMessage)
                            
                            AutoTextFields(name: self.$reg.password,icon: "password_icon", placeholder: "Password",erroMsg:self.reg.passwordMessage)
                            
                            AutoTextFields(name: self.$reg.confirmPassword,icon: "password_icon", placeholder: "Confirm password",erroMsg:self.reg.confirmMessage)
                            
                            GenderView(gender: self.$reg.gender)
                            AutoTextFields(name: self.$reg.phoneNum,icon: "cellphone_icon", placeholder: "Phone number",erroMsg:self.reg.phoneMessage)
                            
                        }
                        
                        VStack(spacing:15){
                            Button(action: {
                                print("click")
                               self.reg.fetch()
                            }){
                                Text("REGISTRATION")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            .disabled(!self.reg.isValid)
                            .frame(width: size.width-40, height: 45, alignment: .center)
                            .background(!self.reg.isValid ? Color.gray : Color.white)
                            .cornerRadius(8)
                            
                        }
                        
                    }
                    
                }.keyboardResponsive()
                    .sheet(isPresented: self.$push) {
                        Login()
                        
                }
                .alert(isPresented: self.$reg.showAlert){
                    return Alert(title: Text(self.reg.errorOrSuceesMsg), dismissButton: .default(Text("OK")){
                        if self.reg.isSuccess{
                            self.push = true
                        }
                    })
                    
                }
                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: self.$reg.isShowing, style: .large)
                }.frame(width: geometry.size.width / 2 - 20,
                   height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.reg.isShowing ? 1 : 0)
                
            }
        }
        
        
    }
    
    
}




struct GenderView:View {
    
    @Binding var gender : String
    
    var body: some View{
        HStack(spacing:30){
            Text("Gender")
                .foregroundColor(Color.white)
                .fontWeight(.bold)
            HStack(spacing:15){
                HStack{
                    
                    Button(action: {
                        self.gender = "F"
                    }) {
                        (self.gender == "F" ? Image("chky") : Image("chkn")).foregroundColor(Color.white)
                    }
                    
                    Text("Female")
                        .foregroundColor(Color.white)
                }
                HStack{
                    Button(action: {
                        self.gender = "M"
                    }) {
                        (self.gender == "M" ? Image("chky") : Image("chkn")).foregroundColor(Color.white)
                    }
                    Text("Male")
                        .foregroundColor(Color.white)
                    
                }
            }
        }
        .padding(.vertical, 12)
    }
    
}
struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration()
    }
}
