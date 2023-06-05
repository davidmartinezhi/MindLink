//
//  PictogramView.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import SwiftUI
import Kingfisher

extension View {
    func pictoSize(_ size: CGFloat) -> some View {
        modifier(PictoSizeMod(size: size))
    }
}

struct PictoSizeMod: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.frame(width: size, height: size)
    }
}

struct PictogramView: View {
    var pictoModel: PictogramModel
    var catModel: CategoryModel
    var displayName: Bool
    var displayCatColor: Bool
    var overlayImage: Image?
    
    var body: some View {
        GeometryReader { geo in
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            ZStack() {
                catModel.buildColor()
                
                VStack {
                    if displayName {
                        Text(pictoModel.name.isEmpty ? "..." : pictoModel.name)
                            .font(.system(size: w * 0.1, weight: .bold))
                            .foregroundColor(.black)
                    }
                    KFImage(URL(string: "https://www.akc.org/wp-content/themes/akc/component-library/assets/img/welcome.jpg"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding(.horizontal, w * 0.05)
                .padding(.vertical, h * 0.05)
                .frame(width: w * (displayCatColor ? 0.9 : 1), height: h * (displayCatColor ? 0.9 : 1))
                .background(.white)
            }
            .border(.black)
            .overlay(alignment: .topTrailing) {
                if overlayImage != nil {
                    overlayImage!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.red)
                        .frame(width: geo.size.width * 0.2)
                        .padding(10)
                }
            }
        }
    }
}

struct PictogramView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World!")
        }
    }
}
