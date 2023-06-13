//
//  xOverCircle.swift
//  Comunicador
//
//  Created by emilio on 06/06/23.
//

import SwiftUI

struct XOverCircleView: View {
    var diameter: Double = 20
    
    var body: some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .foregroundColor(.black)
            .overlay(alignment: .center) {
                Circle()
                    .frame(width: diameter * 0.9, height: diameter * 0.9)
                    .foregroundColor(.white)
                    .overlay(alignment: .center) {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: diameter * 0.5)
                            .foregroundColor(.red)
                    }
            }
    }
}

