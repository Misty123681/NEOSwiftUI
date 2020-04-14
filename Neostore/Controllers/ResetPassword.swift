//
//  ForgotPassword.swift
//  Neostore
//
//  Created by Neosoft on 27/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import SwiftUI

struct ResetPassword: View {
    var body: some View {
        ZStack{
            Color(UIColor.red)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:30){
                Text("NeoSTORE")
                
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
//                VStack{
//                   // TextFields(icon: "password_icon", placeholder: "Current password")
//                    //TextFields(icon: "password_icon", placeholder: "New password")
//                    //TextFields(icon: "password_icon", placeholder: "Confirm password")
//                }
                VStack(spacing:15){
                    Button(action: {
                        print("Login")
                    }){
                        Text("RESET PASSWORD")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .frame(width: size.width-40, height: 45, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(8)

                    
                }
                
                
                
            }
            
        }
        
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
