//
//  PictogramGridArrowView.swift
//  nuevoamanecer
//
//  Created by emilio on 30/08/23.
//

import SwiftUI

struct PictogramGridArrowView: View {
    var systemName: String
    var isDisabled: Bool
    var arrowAction: () -> Void
    
    let colors: [String:Color] = [
        "disabledArrow": Color(red: 0.92, green: 0.92, blue: 0.92),
        // "disabledArrow": Color(red: 0.5, green: 0.5, blue: 0.5),
        "disabledBackground": Color(red: 0.97, green: 0.97, blue: 0.97),
        "arrow": Color(red: 0.65, green: 0.65, blue: 0.65),
        "background": Color(red: 0.75, green: 0.75, blue: 0.75)
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                Button(action: {
                    arrowAction()
                }) {
                    VStack {
                        Image(systemName: systemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                            .foregroundColor(isDisabled ? colors["disabledArrow"] : colors["arrow"])
                    }
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.6)
                    .background(isDisabled ? colors["disabledBackground"] : colors["background"])
                    .cornerRadius(30)
                }
                .allowsHitTesting(!isDisabled)
                
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
