//
//  Home.swift
//  Neostore
//
//  Created by Neosoft on 31/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import SwiftUI

//http://180.149.245.182:8844/trainingapp/webroot/apidoc/index.html#api-A_User-Fetch


//http://design.neosofttech.in/35/NeoSoft/NeoSTORE/Guideline_1.html
//
//
//"confirm_password" = "S@1234";
//        email = "Shiv@gmail.com";
//        "first_name" = Shiv;
//        gender = M;
//        "last_name" = Vishwas;
//        password = "S@1234";
//        "phone_no" = 9865456789;


struct Home: View {
   
    
    var imgProduct = ["chairsicon","cupboardicon","sofaicon","tableicon"]
    var body: some View {
        
         
            VStack(spacing:10) {
                ScrollView {
                    GeometryReader { geometry in
                        ImageCarouselView(numberOfImages: 4) {
                            SilderImg(geometry: geometry, img: "slider_img1")
                            SilderImg(geometry: geometry, img: "slider_img2")
                            SilderImg(geometry: geometry, img: "slider_img3")
                            SilderImg(geometry: geometry, img: "slider_img4")
                        }
                    }.frame(height: 300, alignment: .center)
                    
                }
                GridStack(rows: 2, columns: 2) { row, col in
                
                    Image(self.imgProduct[row * 2 + col])
                }
                
                Spacer()
            
            .navigationBarTitle(Text("Product").font(.largeTitle), displayMode: .inline)


        }
        
    }
    
    
}


struct SilderImg:View {
    
    let geometry: GeometryProxy
    let img :String
    
    var body: some View{
        Image(img)
            .resizable()
            .scaledToFill()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
    }
    
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
    
}
