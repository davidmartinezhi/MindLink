//
//  DoublePictogramPickerView.swift
//  nuevoamanecer
//
//  Created by emilio on 23/06/23.
//

import SwiftUI
import AVFoundation
import Foundation

struct BoardCoordinate {
    var xPos: Double
    var yPos :Double
    var disToCenter: Double {
        return sqrt(pow(xPos, 2) + pow(yPos, 2))
    }
}

func boardCoordinates(disBetweenCoords: Double) -> [BoardCoordinate] {
    var boardCoordinates: [BoardCoordinate] = []
    
    for x in stride(from: -1, to: 1, by: disBetweenCoords){
        for y in stride(from: -1, to: 1, by: disBetweenCoords){
            boardCoordinates.append(BoardCoordinate(xPos: x, yPos: y))
        }
    }
    
    return boardCoordinates
}

func positionPictogramsInPage(pickedPictos: [String:PictogramInPage]) -> [PictogramInPage] {
    var pictosInPage: [PictogramInPage] = []
    let boardCoordinates: [BoardCoordinate] = boardCoordinates(disBetweenCoords: 0.4).sorted{$0.disToCenter < $1.disToCenter}
    var coordinateIndex: Int = 0
    
    for var pictoInPage in pickedPictos.values {
        pictoInPage.xOffset = boardCoordinates[coordinateIndex].xPos
        pictoInPage.yOffset = boardCoordinates[coordinateIndex].yPos
        coordinateIndex = (coordinateIndex + 1) % boardCoordinates.count
        pictosInPage.append(pictoInPage)
    }
    
    return pictosInPage
}

struct DoublePictogramPickerView: View {
    @Binding var pageModel: PageModel
    @State var pickedPictos: [String:PictogramInPage] = [:]
    
    @Binding var isPresented: Bool 
    
    var pictoCollectionPath1: String
    var catCollectionPath1: String
    var pictoCollectionPath2: String
    var catCollectionPath2: String
    
    @State var showingPictogramPicker1: Bool = true
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Pictogram Picker 1
                PictogramPickerView(pickedPictos: $pickedPictos, pictoCollectionPath: pictoCollectionPath1, catCollectionPath: catCollectionPath1, showSwitchView: true, onLeftOfSwitch: $showingPictogramPicker1)
                .zIndex(showingPictogramPicker1 ? 1 : 0)
                
                // Pictogram Picker 2
                PictogramPickerView(pickedPictos: $pickedPictos, pictoCollectionPath: pictoCollectionPath2, catCollectionPath: catCollectionPath2, showSwitchView: true, onLeftOfSwitch: $showingPictogramPicker1)
                .zIndex(showingPictogramPicker1 ? 0 : 1)
            }
            .overlay(alignment: .top) {
                VStack {
                    let pictosChosen: Bool = pickedPictos.count > 0
                    ButtonWithImageView(text: pictosChosen ? "Añadir Pictogramas" : "Cancelar", systemNameImage: pictosChosen ? "plus" : "xmark") {
                        if pictosChosen {
                            pageModel.pictogramsInPage += positionPictogramsInPage(pickedPictos: pickedPictos)
                        }
                        isPresented = false
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}
