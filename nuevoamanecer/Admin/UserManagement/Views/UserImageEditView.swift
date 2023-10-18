//
//  UserImageView.swift
//  nuevoamanecer
//
//  Created by emilio on 09/10/23.
//

import SwiftUI
import Kingfisher

struct UserImageEditView: View {
    @Binding var user: User
    let initialImage: String?
    @Binding var overlayingImage: UIImage?
    let isBeingEdited: Bool
    
    @State var showImageEditMenu: Bool = false
    @State var showImagePicker: Bool = false
        
    init(user: Binding<User>, initialImage: String?, overlayingImage: Binding<UIImage?>, isBeingEdited: Bool){
        self._user = user
        self.initialImage = initialImage
        self._overlayingImage = overlayingImage
        self.isBeingEdited = isBeingEdited
    }
    
    var body: some View {
        Menu(content: {imageEditMenu}, label: {userImageDisplay})
            .fullScreenCover(isPresented: $showImagePicker){
                ImagePicker(image: $overlayingImage)
            }
            .allowsHitTesting(isBeingEdited)
    }
    
    var userImageDisplay: some View {
        VStack {
            if overlayingImage != nil {
                Image(uiImage: overlayingImage!)
                    .resizable()
                    .modifier(UserImageStyle())
            } else {
                KFImage(URL(string: user.image ?? ""))
                    .placeholder {
                        let nameComponents: [String] = self.user.name.splitAtWhitespaces()
                        ImagePlaceholderView(firstName: nameComponents.getElementSafely(index: 0) ?? "",
                                             lastName: nameComponents.getElementSafely(index: 1) ?? "")
                    }
                    .resizable()
                    .modifier(UserImageStyle())
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isBeingEdited {
                Image(systemName: "photo.on.rectangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundColor(.black)
            }
        }
        .overlay(alignment: .leading) {
            if isBeingEdited {
                ChangeIndicatorView(showIndicator: overlayingImage != nil || user.image != initialImage)
                    .offset(x: -20)
            }
        }
    }
    
    var imageEditMenu: some View {
        Section {
            if user.image != nil || overlayingImage != nil {
                Button {
                    if overlayingImage != nil {
                        overlayingImage = nil
                    } else {
                        user.image = nil
                    }
                } label: {
                    Label(overlayingImage != nil ? "Cancelar selección" : "Eliminar imagén" , systemImage: "xmark")
                }
            }
            
            Button {
                showImagePicker = true
            } label: {
                Label("Seleccionar una imagén", systemImage: "square.and.arrow.up")
            }
        }
    }
}

struct UserImageStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
    }
}
