//
//  PictogramScaleModifierView.swift
//  nuevoamanecer
//
//  Created by emilio on 25/06/23.
//

import SwiftUI

struct PictogramScaleModifierView: View {
    @Binding var scale: Double
    var initialHeight: CGFloat
    
    let scaleChangeValue: Double = 0.1
    var maxScale: Double = 3
    var minScale: Double = 0.5

    var body: some View {
        HStack(spacing: 20) {
            Button {
                if scale > minScale {
                    withAnimation(nil){
                        scale -= scaleChangeValue
                    }
                }
            } label: {
                Image(systemName: "minus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            }
            
            Text(String(format: "%.1f", scale))
                .font(.system(size: 20 * scale))
            
            Button {
                if scale < maxScale {
                    withAnimation(nil){
                        scale += scaleChangeValue
                    }
                }
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .frame(height: initialHeight * scale)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(20)
    }
}
