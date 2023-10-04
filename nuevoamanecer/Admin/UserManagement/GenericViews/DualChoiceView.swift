//
//  DualChoiceView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/09/23.
//

import SwiftUI

struct DualChoiceView: View {
    @Binding var choice: Bool
    var width: CGFloat = 80
    var height: CGFloat = 30
    var labels: (String, String)
    var isBeingEdited: Bool
    var isDisabled: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                .overlay(alignment: choice ? .leading : .trailing){
                    Rectangle()
                        .frame(width: width/2, height: height)
                        .foregroundColor(choice ? .green : .red)
                }
            
            HStack(spacing: width/4) {
                Button {
                    withAnimation {
                        choice = true
                    }
                } label: {
                    Text(labels.0)
                }
                
                Button {
                    withAnimation {
                        choice = false
                    }
                } label: {
                    Text(labels.1)
                }
            }
            .foregroundColor(.black)
            .allowsHitTesting(!isDisabled)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        //.border(.gray, width: isBeingEdited ? 1 : 0)
    }
}

