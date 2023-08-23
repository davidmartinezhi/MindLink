//
//  MarkedScrollView.swift
//  nuevoamanecer
//
//  Created by emilio on 22/08/23.
//

import SwiftUI

enum ScrollDirection {
    case horizontal, vertical
}

struct MarkedScrollView<Content: View>: View {
    let scrollDirection: ScrollDirection
    let offset: CGFloat = 20
    @ViewBuilder let content: () -> Content
    @State private var scrollViewFrame: CGRect = .zero
    @State private var contentFrame: CGRect = .zero
    
    var body: some View {
        ScrollView(scrollDirection == .horizontal ? .horizontal : .vertical){
            content()
                .background {
                    GeometryReader { contentGeo in
                        Color.clear
                            .onAppear {
                                contentFrame = contentGeo.frame(in: .global)
                            }
                            .onChange(of: contentGeo.frame(in: .global)) { newContentFrame in
                                contentFrame = newContentFrame
                            }
                    }
                }
        }
        .coordinateSpace(name: "markedScrollViewCoordSpace")
        .background {
            GeometryReader { scrollViewGeo in
                Color.clear
                    .onAppear {
                        scrollViewFrame = scrollViewGeo.frame(in: .global)
                    }
                    .onChange(of: scrollViewGeo.frame(in: .global)) { newScrollViewFrame in
                        scrollViewFrame = newScrollViewFrame
                    }
            }
        }
        .overlay(alignment: .center) {
            if scrollDirection == .horizontal {
                marksHorizontal
                    .allowsHitTesting(false)
            } else {
                marksVertical
                    .allowsHitTesting(false)
            }
        }
    }
    
    var marksHorizontal: some View {
        HStack {
            Image(systemName: "arrowshape.backward.fill")
                .opacity(contentFrame.minX < scrollViewFrame.minX - offset ? 0.9 : 0)
            Spacer()
            Image(systemName: "arrowshape.right.fill")
                .opacity(contentFrame.maxX > scrollViewFrame.maxX + offset ? 0.9 : 0)
        }
    }
    
    var marksVertical: some View {
        VStack {
            Image(systemName: "arrowshape.backward.fill")
                .rotationEffect(.degrees(90))
                .opacity(contentFrame.minY < scrollViewFrame.minY - offset ? 0.9 : 0)
            Spacer()
            Image(systemName: "arrowshape.right.fill")
                .rotationEffect(.degrees(90))
                .opacity(contentFrame.maxY > scrollViewFrame.maxY + offset ? 0.9 : 0)
        }
    }
}
