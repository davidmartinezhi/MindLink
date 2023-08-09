//
//  PictogramHolderView.swift
//  nuevoamanecer
//
//  Created by emilio on 22/06/23.
//

import SwiftUI

struct EditPictogramHolderView: View {
    var pictoModel: PictogramModel?
    var catModel: CategoryModel? 
    @Binding var pictoInPage: PictogramInPage
    var performWhenDeleted: (PictogramInPage)->Void
    
    var pictoBaseWidth: CGFloat
    var pictoBaseHeight: CGFloat
    var spaceWidth: CGFloat
    var spaceHeight: CGFloat
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let newXOffset: CGFloat = (value.translation.width / (spaceWidth / 2)) + pictoInPage.xOffset
                let newYOffset: CGFloat = (value.translation.height / (spaceHeight / 2)) + pictoInPage.yOffset
                
                if newXOffset < 1 && newXOffset > -1 {
                    pictoInPage.xOffset = newXOffset
                }
                
                if newYOffset < 1 && newYOffset > -1 {
                    pictoInPage.yOffset = newYOffset
                }
            }
    }
        
    var body: some View {
        VStack {
            PictogramScaleModifierView(scale: $pictoInPage.scale, initialHeight: 50)

            VStack {
                if pictoModel == nil || catModel == nil {
                    PictogramPlaceholderView()
                        .gesture(dragGesture)
                } else {
                    PictogramView(pictoModel: pictoModel!, catModel: catModel!, displayName: true, displayCatColor: true)
                        .gesture(dragGesture)
                }
            }
            .frame(width: pictoBaseWidth * pictoInPage.scale, height: pictoBaseHeight * pictoInPage.scale)
            .overlay(alignment: .topTrailing){
                Image(systemName: "hand.point.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: (pictoBaseWidth * 0.15) * pictoInPage.scale)
                    .padding()
                    .foregroundColor(.gray)
                    .opacity(0.4)
            }
            
            ButtonWithImageView(text: "Eliminar", systemNameImage: "trash", background: .red){
                performWhenDeleted(pictoInPage)
            }
        }
        .offset(x: (spaceWidth / 2) * pictoInPage.xOffset, y: (spaceHeight / 2) * pictoInPage.yOffset)
    }
}
