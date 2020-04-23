//MenuView.swift

//Created by BLCKBIRDS on 26.10.19.
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        VStack(alignment: .leading,spacing: 20) {
            
            NavigationLink(destination: Home()) {
                
                Text("Home")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            
            Spacer()
            
        }
        .padding(.top, 100)
        .padding(.leading, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
