//
//  customTextField.swift
//  Neostore
//
//  Created by Neosoft on 30/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import Foundation
import SwiftUI
struct AutoTextFields:View {
    
    @Binding var name: String
    let icon :String
    let placeholder: String
    var erroMsg  : String

    var isSecure = false
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 45, alignment: .center)
                .foregroundColor(Color.clear)
                .border(Color.white, width: 2)
                .padding(EdgeInsets(top: 3, leading: 20, bottom: 3, trailing: 20))
                .overlay(
                    HStack(spacing:15){
                        Image(icon)
                            .foregroundColor(.white)
                        if isSecure{
                            
                            SecureField(placeholder,text: $name).foregroundColor(Color.white)
                            
                        }else{
                            
                            TextField(placeholder, text: $name).foregroundColor(Color.white)
                            
                        }
                    }
                    .padding()
                    .frame(width: size.width-40, alignment: .center)
                    
            )
            Text(erroMsg).frame(minWidth:0, maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing,20)
                .foregroundColor(Color.gray)
                .font(.subheadline)

        }
        
    }
    
}
