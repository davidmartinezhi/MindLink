//
//  ScrollPercentage.swift
//  nuevoamanecer
//
//  Created by emilio on 19/08/23.
//

import Foundation
import SwiftUI

enum ScrollDirection {
    case horizontal, vertical
}

// El modificador es aplicado a vistas cuyo contenido es "scrolleado" dentro de un ScrollView.
struct ScrollOffset: ViewModifier {
    @Binding var offset: Double 
    let direction: ScrollDirection
    let coordinateSpaceName: String
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.frame(in: .named(coordinateSpaceName)).origin) { newOrigin in
                            offset = direction == .horizontal ? newOrigin.x : newOrigin.y
                        }
                }
            }
    }
}

extension View {
    func scrollOffset(_ offset: Binding<Double>, direction: ScrollDirection, coordinateSpaceName: String) -> some View {
        return self.modifier(ScrollOffset(offset: offset, direction: direction, coordinateSpaceName: coordinateSpaceName))
    }
}
