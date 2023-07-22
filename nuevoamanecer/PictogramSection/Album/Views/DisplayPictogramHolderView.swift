//
//  DisplayPictogramHolderView.swift
//  nuevoamanecer
//
//  Created by emilio on 22/06/23.
//

import SwiftUI

struct DisplayPictogramHolderView: View {
    var pictoModel: PictogramModel?
    var catModel: CategoryModel?
    @Binding var pictoInPage: PictogramInPage
    
    var soundOn: Bool
    
    var pictoBaseWidth: CGFloat
    var pictoBaseHeight: CGFloat
    var spaceWidth: CGFloat
    var spaceHeight: CGFloat
    
    var body: some View {
        VStack {
            if pictoModel == nil || catModel == nil {
                PictogramPlaceholderView()
            } else {
                Button {
                    // Reproducir el nombre del pictograma (Text-To-Speech)
                } label: {
                    PictogramView(pictoModel: pictoModel!, catModel: catModel!, displayName: true, displayCatColor: true)
                }
                .allowsHitTesting(soundOn)
            }
        }
        .frame(width: pictoBaseWidth * pictoInPage.scale, height: pictoBaseHeight * pictoInPage.scale)
        .offset(x: (spaceWidth / 2) * pictoInPage.xOffset, y: (spaceHeight / 2) * pictoInPage.yOffset)
    }
}
