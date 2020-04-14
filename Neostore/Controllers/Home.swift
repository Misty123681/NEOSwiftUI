//
//  Home.swift
//  Neostore
//
//  Created by Neosoft on 31/03/20.
//  Copyright © 2020 Neosoft. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State var current = 0
    var items = [Color.red, Color.orange, Color.yellow, Color.green,                 Color.blue, Color.purple]
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: true){
                HStack{
                    ForEach(self.items, id: \.self) { item in
                        // 3.
                        Circle()
                            .fill(item)
                            .frame(width: 100, height:
                                100)
                        
                        
                    }
                    
                }
            }.padding(.horizontal,4)
            ImagePagination(currentIndex: current)
            
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
