//
//  PictogramGridView.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramGridArrowView: View {
    var systemName: String
    var isDisabled: Bool
    var arrowAction: () -> Void
    
    let colors: [String:Color] = [
        "disabledArrow": Color(red: 0.92, green: 0.92, blue: 0.92),
        "disabledBackground": Color(red: 0.97, green: 0.97, blue: 0.97),
        "arrow": Color(red: 0.8, green: 0.8, blue: 0.8),
        "background": Color(red: 0.87, green: 0.87, blue: 0.87)
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

struct PictogramGridView: View {
    let pictograms: [Button<PictogramView>]
    let pictoWidth: CGFloat
    let pictoHeight: CGFloat
    @State private var currPage: Int = 1
    
    var body: some View {
        GeometryReader { geo in
            let gridWidth: CGFloat = geo.size.width * 0.8
            let gridHeight: CGFloat = geo.size.height * 0.95
            let gridHorSpacing: Double = 25
            let gridVerSpacing: Double = 25
            let _numColumns: Int = Int((gridWidth + gridHorSpacing) / (pictoWidth + gridHorSpacing))
            let _numRows: Int = Int((gridHeight + gridVerSpacing) / (pictoHeight + gridVerSpacing))
            let numColumns: Int = _numColumns == 0 ? 1 : _numColumns
            let numRows: Int = _numRows == 0 ? 1 : _numRows
            let numGridItems: Int = numColumns * numRows
            let numPages: Int = ceiling(pictograms.count, numGridItems) == 0 ? 1 : ceiling(pictograms.count, numGridItems)
                    
            HStack {
                Spacer()

                PictogramGridArrowView(systemName: "arrow.left", isDisabled: realCurrPage(numPages: numPages) == 1) {
                    currPage = realCurrPage(numPages: numPages)
                    currPage = currPage - 1
                }
                
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
                    
                    Spacer()
                }
                .overlay(alignment: .bottom){
                    Text("\(realCurrPage(numPages: numPages))/\(numPages)")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                }
                
                PictogramGridArrowView(systemName: "arrow.right", isDisabled: realCurrPage(numPages: numPages) == numPages) {
                    currPage = realCurrPage(numPages: numPages)
                    currPage = currPage + 1
                }
                
                Spacer()
            }
        }
        .background(.white)
    }
    
    private func realCurrPage(numPages: Int) -> Int {
        return currPage > numPages ? numPages : currPage
    }
    
    private func ceiling(_ a: Int, _ b: Int) -> Int {
        return Int(ceil(Double(a) / Double(b)))
    }
}
