//
//  AdminNav.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 05/06/23.
//

import SwiftUI

struct AdminNav: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var showLogoutAlert: Bool

    var body: some View {
        ZStack {
            Color(.sRGB, red: 50/255, green: 50/255, blue: 50/255, opacity: 1.0).edgesIgnoringSafeArea(.top)
            HStack {
                Image("logo")
                    .resizable()
                    .renderingMode(.template) // Para poder cambiar el color del logo
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40) // Ajuste a la altura deseada
                Spacer()
                Button(action: {
                    // Aquí puedes poner la funcionalidad para ir a la página de perfil del usuario
                }) {
                    Image("profile") // Asegúrate de que la imagen "profile" esté en tus activos
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                Button(action: {
                    self.showLogoutAlert.toggle()
                }) {
                    Image(systemName: "gearshape")
                }
            }
            .padding(.horizontal, 50)
        }
        .frame(height: 70) // Ajusta este valor para cambiar la altura de la barra de navegación
        .foregroundColor(.white) // Esto cambiará el color de los íconos y el texto
        .overlay(
            Rectangle()
                .fill(Color.gray)
                .frame(height: 0.5) // Hacemos el borde más sutil
                .edgesIgnoringSafeArea(.horizontal), alignment: .bottom
        )
    }
}



struct AdminNav_Previews: PreviewProvider {
    static var previews: some View {
        AdminNav(authViewModel: AuthViewModel(), showLogoutAlert: .constant(false))
    }
}
