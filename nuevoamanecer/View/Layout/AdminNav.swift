//
//  AdminNav.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 05/06/23.
//

import SwiftUI
import Kingfisher

struct AdminNav: View {
    
    @Binding var showAdminMenu: Bool
    var user: User


    var body: some View {
        ZStack {
            HStack {
                Image("logo_name")
                    .resizable()
                    //.renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .padding()
                Spacer()
                Button(action: { showAdminMenu = true }) {
                    
                    //if(user.image != ""){
                      //  Image(systemName: "person.fill")
                      //      .font(.system(size: 20))
                      //      .padding()
                      //      .foregroundColor(Color(.label))
                    //}else{
                    if(user.image == "") {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        KFImage(URL(string: user.image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .padding()
                    }
                    //}
                }
            }
            .padding(.horizontal, 50)
        }
        .frame(height: 70)
        .foregroundColor(.white)
        /*
        .overlay(
            Rectangle()
                .fill(Color.gray)
                .frame(height: 0.5)
                .edgesIgnoringSafeArea(.horizontal), alignment: .bottom
        )
         */
    }
}





struct AdminNav_Previews: PreviewProvider {
    static var previews: some View {
        AdminNav(showAdminMenu: .constant(false), user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
    }
}
