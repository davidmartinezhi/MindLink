//
//  PictogramGridView.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramGridArrowView: View {
    var width: CGFloat
    var height: CGFloat
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
        Button(action: {
            arrowAction()
        }) {
            VStack {
                Image(systemName: systemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .foregroundColor(isDisabled ? colors["disabledArrow"] : colors["arrow"])
            }
            .padding()
            .frame(width: width, height: height)
            .background(isDisabled ? colors["disabledBackground"] : colors["background"])
            .cornerRadius(30)
        }
        .allowsHitTesting(!isDisabled)
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
            let gridHeight: CGFloat = geo.size.height * 0.9
            let numColumns: Int = Int(gridWidth / pictoWidth)
            let numRows: Int = Int(gridHeight / pictoHeight)
            let numGridItems: Int = numColumns * numRows
            let numPages: Int = ceiling(pictograms.count, numGridItems) == 0 ? 1 : ceiling(pictograms.count, numGridItems)
                    
            HStack(spacing: 5) {
                Spacer()
                
                PictogramGridArrowView(width: (geo.size.width - gridWidth) * 0.4,
                                       height: gridHeight * 0.8,
                                       systemName: "arrow.left",
                                       isDisabled: realCurrPage(numPages: numPages) == 1) {
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
                    
                    Text("\(realCurrPage(numPages: numPages))/\(numPages)")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .padding()
                }
                
                PictogramGridArrowView(width: (geo.size.width - gridWidth) * 0.4,
                                       height: gridHeight * 0.8,
                                       systemName: "arrow.right",
                                       isDisabled: realCurrPage(numPages: numPages) == numPages) {
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
