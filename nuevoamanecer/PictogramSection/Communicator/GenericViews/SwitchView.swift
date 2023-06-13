//
//  SwitchView.swift
//  nuevoamanecer
//
//  Created by emilio on 11/06/23.
//

import SwiftUI

struct SwitchView: View {
    @Binding var onLeft: Bool

    var leftText: String
    var rightText: String
    var width: CGFloat = 300
    var height: CGFloat = 50
    var backgroundColor: Color = .white
    var foregroundColor: Color = .blue
    var textColor: Color = .black
    
    var isDisabled: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(backgroundColor)
                .overlay(alignment: .center) {
                    Rectangle()
                        .frame(width: width/2, height: height)
                        .foregroundColor(isDisabled ? .gray : foregroundColor)
                        .cornerRadius(10)
                        .offset(x: onLeft ? ((width/2) * -1) +  width/4: (width/2) - width/4)
                }
            
            HStack(spacing: 0){
                Button {
                    withAnimation {
                        onLeft = true
                    }
                } label: {
                    Text(leftText)
                        .frame(width: width/2, height: height)
                        .foregroundColor(textColor)
                        .bold()
                }
                .allowsHitTesting(!onLeft && !isDisabled)
                
                Button {
                    withAnimation {
                        onLeft = false 
                    }
                } label: {
                    Text(rightText)
                        .frame(width: width/2, height: height)
                        .foregroundColor(textColor)
                        .bold()
                }
                .allowsHitTesting(onLeft && !isDisabled)
            }
            .cornerRadius(10)
        }
        .background(backgroundColor)
        .cornerRadius(10)
    }
}
