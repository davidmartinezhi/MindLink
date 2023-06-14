//
//  ButtonViewImage.swift
//  nuevoamanecer
//
//  Created by emilio on 14/06/23.
//

import SwiftUI

enum ImagePosition {
    case left
    case right
}

struct ButtonWithImageView: View {
    var text: String
    var width: CGFloat = 150
    var height: CGFloat = 50
    var systemNameImage: String
    var imagePosition: ImagePosition = .right
    var imagePadding: CGFloat = 10
    var background: Color = Color.blue
    var isDisabled: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action){
            HStack {
                if imagePosition == .left {
                    Image(systemName: systemNameImage)
                        .padding(.trailing, imagePadding)
                }
                
                Text(text)
                    .font(.headline)
                
                if imagePosition == .right {
                    Image(systemName: systemNameImage)
                        .padding(.leading, imagePadding)
                }
            }
        }
        .padding(10)
        .frame(width: width, height: height)
        .background(isDisabled ? Color.gray : self.background)
        .cornerRadius(10)
        .foregroundColor(.white)
        .allowsHitTesting(!isDisabled)
    }
}
