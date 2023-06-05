//
//  PictogramGridView.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramGridView: View {
    let pictograms: [Button<PictogramView>]
    let pictoWidth: CGFloat
    let pictoHeight: CGFloat
    @State private var currPage: Int = 1
    
    var body: some View {
        GeometryReader { geo in
            let gridWidth: CGFloat = geo.size.width * 0.8
            let gridHeight: CGFloat = geo.size.height * 0.9
            let numColumns: Int = Int(gridWidth / pictoWidth)
            let numRows: Int = Int(gridHeight / pictoHeight)
            let numGridItems: Int = numColumns * numRows
            let numPages: Int = Int(pictograms.count / numGridItems) + 1
        
            HStack(spacing: 0) {
                Spacer()
                
                Button(action: {
                    currPage = realCurrPage(numPages: numPages)
                    currPage = currPage - 1
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .padding()
                }
                .disabled(realCurrPage(numPages: numPages) == 1)
                
                VStack {
                    Spacer()
                    
                    Grid(horizontalSpacing: 25, verticalSpacing: 25) {
                        ForEach(1...numRows, id: \.self){ row in
                            GridRow {
                                ForEach(1...numColumns, id: \.self) { col in
                                    let gridItemNumber: Int = (col + ((row - 1) * numColumns))
                                    let pictoIndex: Int = ((gridItemNumber - 1) + ((realCurrPage(numPages: numPages) - 1) * numGridItems))
                                    if pictoIndex < pictograms.count {
                                        pictograms[pictoIndex]
                                            .frame(width: pictoWidth, height: pictoHeight)
                                    } else {
                                        Rectangle()
                                            .frame(width: pictoWidth, height: pictoHeight)
                                            .foregroundColor(.gray)
                                            .opacity(0.1)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: gridWidth, height: gridHeight)
                    
                    Text("\(realCurrPage(numPages: numPages))/\(numPages)")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                }
                .frame(maxHeight: .infinity)

                Button(action: {
                    currPage = realCurrPage(numPages: numPages)
                    currPage = currPage + 1
                }) {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .padding()
                }
                .disabled(realCurrPage(numPages: numPages) == numPages)
                
                Spacer()
            }
        }
    }
    
    private func realCurrPage(numPages: Int) -> Int {
        return currPage > numPages ? numPages : currPage
    }
}
