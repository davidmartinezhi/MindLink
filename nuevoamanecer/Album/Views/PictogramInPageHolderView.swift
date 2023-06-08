//
//  PictogramInPageHolderView.swift
//  nuevoamanecer
//
//  Created by emilio on 08/06/23.
//

import SwiftUI

struct PictogramInPageHolderView: View {
    var pictogramView: PictogramView
    @Binding var pictogramInPage: PictogramInPage
    var basePictogramWidth: CGFloat = 200
    var basePictogramHeight: CGFloat = 200
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.pictogramInPage.xPos = Double(value.location.x)
                self.pictogramInPage.yPos = Double(value.location.y)
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                self.pictogramInPage.scale = Double(value.magnitude)
            }
    }
        
    var body: some View {
        pictogramView
            .frame(width: basePictogramWidth * pictogramInPage.scale, height: basePictogramHeight * pictogramInPage.scale)
            .offset(x: pictogramInPage.xPos, y: pictogramInPage.yPos)
            .gesture(SimultaneousGesture(dragGesture, magnificationGesture))
    }
}

struct PictogramInPageHolderView_Previews: PreviewProvider {
    static var previews: some View {
        Text("...")
    }
}
