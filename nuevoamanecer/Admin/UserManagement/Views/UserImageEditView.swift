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
    @Binding var pickedUserImage: UIImage?
    let isBeingEdited: Bool
    
    @State var showImagePicker: Bool = false
    
    var body: some View {
        VStack {
            if pickedUserImage != nil {
                Image(uiImage: pickedUserImage!)
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
        .onTapGesture {
            if isBeingEdited {
                showImagePicker = true
            }
        }
        .overlay(alignment: .bottom) {
            if isBeingEdited {
                editImageBar
                    .offset(y: 10)
            }
        }
        .overlay(alignment: .leading) {
            if isBeingEdited {
                ChangeIndicatorView(showIndicator: pickedUserImage != nil)
                    .offset(x: -20)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker){
            ImagePicker(image: $pickedUserImage)
        }
    }
    
    var editImageBar: some View {
        HStack {
            if pickedUserImage != nil {
                Button {
                    pickedUserImage = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .foregroundColor(.red)
                }
            }

            Spacer()
            
            Image(systemName: "photo.on.rectangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
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
