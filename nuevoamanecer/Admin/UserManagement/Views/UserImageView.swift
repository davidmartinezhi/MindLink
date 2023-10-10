//
//  UserImageView.swift
//  nuevoamanecer
//
//  Created by emilio on 09/10/23.
//

import SwiftUI
import Kingfisher

struct UserImageView: View {
    let user: User
    let isBeingEdited: Bool
    @Binding var showImagePicker: Bool
    
    var body: some View {
        KFImage(URL(string: user.image ?? ""))
            .placeholder {
                let nameComponents: [String] = self.user.name.splitAtWhitespaces()
                ImagePlaceholderView(firstName: nameComponents.getElementSafely(index: 0) ?? "",
                                     lastName: nameComponents.getElementSafely(index: 1) ?? "")
            }
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(alignment: .center) {
                if isBeingEdited {
                    Image(systemName: "photo.on.rectangle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .offset(x: 50, y: 50)
                }
            }
            .onTapGesture {
                if isBeingEdited {
                    showImagePicker = true
                }
            }
    }
}
