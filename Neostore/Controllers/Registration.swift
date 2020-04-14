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
    
    var body: some View {
        ZStack{
            Color(UIColor.red)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing:30){
                    Text("NeoSTORE")
                        .padding(.top, 70)
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                    VStack{
                        AutoTextFields(name: $reg.firstName, icon: "username_icon", placeholder: "First name",erroMsg:reg.firstMessage)
                        
                        AutoTextFields(name: $reg.lastName,icon: "username_icon", placeholder: "Last name",erroMsg:reg.lastMessage)
                        
                        
                        AutoTextFields(name: $reg.email,icon: "email_icon", placeholder: "Email",erroMsg:reg.emailMessage)
                        
                        AutoTextFields(name: $reg.password,icon: "password_icon", placeholder: "Password",erroMsg:reg.passwordMessage)
                        
                        AutoTextFields(name: $reg.confirmPassword,icon: "password_icon", placeholder: "Confirm password",erroMsg:reg.confirmMessage)
                        
                        GenderView(gender: $reg.gender)
                        AutoTextFields(name: $reg.phoneNum,icon: "cellphone_icon", placeholder: "Phone number",erroMsg:reg.phoneMessage)

                    }
                    
                    VStack(spacing:15){
                        Button(action: {
                            print("click")
                            // self.reg.fetch()
                        }){
                            Text("REGISTRATION")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                            //disabled(!reg.isValid)
                            .frame(width: size.width-40, height: 45, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        
                    }
                    
                }
                
            }
        }
            
//            .onAppear(){
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
//                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                    let height = value.height
//                    self.value = height
//                }
//
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
//                    self.value = 0
//                }
//        }
        
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
