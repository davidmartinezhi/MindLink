//
//  AdminMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI
import Kingfisher

struct AdminMenuView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    
    var user: User
    @State private var name: String

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var showLogoutAlert = false
    
    @State private var upload_image: UIImage?
    @State private var shouldShowImagePicker: Bool = false
    @State private var uploadData: Bool = false
    @State private var imageURL = URL(string: "")
    @State private var storage = FirebaseAlmacenamiento()

    init(authViewModel: AuthViewModel, user: User) {
        self.authViewModel = authViewModel
        self.user = user
        _name = State(initialValue: user.name)
    }
    
    var body: some View {
        VStack {
            
            //Logout button
            HStack{
                Button(action: {
                    self.showLogoutAlert.toggle()
                }) {
                    HStack {
                        Text("Cerrar sesión")
                            .font(.system(size: 16))
                        
                        Spacer()
                        
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .font(.system(size: 12))
                    }
                }
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(maxWidth: 170)
                
                Spacer()
            }
            
            VStack {
                
                //Imagen del niño
                VStack{
                    Button() {
                        shouldShowImagePicker.toggle()
                    } label: {
                        if let displayImage = self.upload_image {
                            Image(uiImage: displayImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(128)
                                .padding(.horizontal, 20)
                        } else {
                                //No imagen
                            if(user.image == "placeholder" || user.image == "") {
                                    ZStack{
                                        Image(systemName: "person.circle")
                                            .font(.system(size: 100))
                                        //.foregroundColor(Color(.label))
                                            .foregroundColor(.gray)
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 25))
                                            .offset(x: 35, y: 40)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal, 20)
                                }
                                
                                //Imagen previamente subida
                                else{
                                    
                                    ZStack{
                                        KFImage(URL(string: user.image))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 128, height: 128)
                                            .cornerRadius(128)
                                            .padding(.horizontal, 20)
                                        
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.system(size: 40))
                                            .offset(x: 40, y: 40)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.horizontal, 20)
                                }
                        }
                    }
                    //Spacer()
                }
                .frame(maxHeight: 150)
                
                /*
                Image(systemName: "person.circle")
                    .font(.system(size: 80))
                    //.foregroundColor(Color(.label))
                    .foregroundColor(.gray)
                 */
                
                Text(name)
                    .font(.title)
                    .bold()
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            .frame(maxHeight: 200)
            //.padding(.top, 50)
            
            VStack{
                Form {
                    Section(header: Text("Información")) {
                        TextField("Nombre", text: $name)
                    }
                }
            }
            .frame(maxHeight: 300)
            
            //Spacer()
            VStack(alignment: .leading, spacing: 10) {
                
                HStack{
                    //Cancelar
                    Button(action: {
                        dismiss()
                    }){
                        HStack {
                            Text("Cancelar")
                                .font(.headline)
                            
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                    
                    //Guardar
                    Button(action: {
                        
                        
                        
                        
                        if let thisImage = self.upload_image {
                            Task {
                                await storage.uploadImage(image: thisImage, name: user.name + "admin_profile_picture") { url in
                                    
                                    imageURL = url
                                    
                                    //Checar que datos son validos
                                    if (name == "") {
                                        self.alertTitle = "Faltan campos"
                                        self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                                        self.showingAlert = true
                                        
                                    }
                                    else{
                                        uploadData.toggle()
                                        dismiss()
                                    }
                                }
                            }
                        } else {
                            //Checar que datos son validos
                            if (name == "") {
                                self.alertTitle = "Faltan campos"
                                self.alertMessage = "Por favor, rellena todos los campos antes de guardar la nota."
                                self.showingAlert = true
                                
                            }
                            else{
                                uploadData.toggle()
                                dismiss()
                            }
                        }
                        
                        
                        
                        
                    
                    }) {
                        HStack {
                            Text("Guardar")
                                .font(.headline)
                            
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                //.padding(.bottom)

                /**
                Button(action: {
                    self.showLogoutAlert.toggle()
                }) {
                    HStack {
                        Text("Cerrar sesión")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "arrowshape.turn.up.left.fill")
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.red)
                 */
            }
            .padding()
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Cerrar Sesión"),
                    message: Text("¿Estás seguro que quieres cerrar la sesión?"),
                    primaryButton: .destructive(Text("Cerrar sesión"), action: {
                       authViewModel.logout()
                    }),
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $upload_image)
        }
        .onDisappear{
            if(uploadData) {
                self.name = name
                
                authViewModel.updateUser(name: name, isAdmin: user.isAdmin, image: imageURL?.absoluteString ?? "placeholder")
            }
        }
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView(authViewModel: AuthViewModel() ,user: User(id: "", name: "", email: "", isAdmin: false, image: ""))
    }
}
