//
//  PictogramGridView.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramGridView: View {
    let pictograms: [PictogramView]
    let pictoWidth: CGFloat
    let pictoHeight: CGFloat
    var handlePictogramAddition: (() -> Void)? = nil
    
    @State private var currPage: Int = 1
    
    var body: some View {
        let editingPictograms: Bool = handlePictogramAddition != nil
        
        GeometryReader { geo in
            let gridWidth: CGFloat = geo.size.width * (geo.size.height > geo.size.width ? 0.7 : 0.8)
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
                        ForEach(1...numRows, id: \.self){ rowNum in
                            GridRow {
                                ForEach(1...numColumns, id: \.self) { colNum in
                                    let gridItemNumber: Int = (colNum + ((rowNum - 1) * numColumns))
                                    let pictoIndex: Int = ((gridItemNumber - 1) + ((realCurrPage(numPages: numPages) - 1) * numGridItems)) - (editingPictograms ? 1 : 0)
                                    
                                    if editingPictograms && rowNum == 1 && colNum == 1 {
                                        AddPictogramButton(width: pictoWidth, height: pictoHeight)
                                            .onTapGesture {
                                                handlePictogramAddition!()
                                            }
                                    } else if pictoIndex < pictograms.count {
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

struct AddPictogramButton: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "plus")
                .resizable()
                .frame(width: 70, height: 70)
            Spacer()
            Text("Nuevo Pictograma")
        }
        .foregroundColor(.blue)
        .frame(width: width, height: height)
    }
}
