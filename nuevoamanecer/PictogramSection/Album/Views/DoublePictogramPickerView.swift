//
//  DoublePictogramPickerView.swift
//  nuevoamanecer
//
//  Created by emilio on 23/06/23.
//

import SwiftUI
import AVFoundation

func positionPictogramsInPage(pickedPictos: [String:PictogramInPage]) -> [PictogramInPage] {
    var pictosInPage: [PictogramInPage] = []
    
    for var (i, pictoInPage) in pickedPictos.values.enumerated() {
        pictoInPage.xOffset = Double(i) * 0.1
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
                    ButtonWithImageView(text: pictosChosen ? "Añadir Pictogramas" : "Cancelar", width: 220, height: 50, systemNameImage: pictosChosen ? "plus" : "xmark") {
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
