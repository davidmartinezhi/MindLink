//
//  DoublePictogramPickerView.swift
//  nuevoamanecer
//
//  Created by emilio on 23/06/23.
//

import SwiftUI
import AVFoundation

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
            .onDisappear {
                pageModel.pictogramsInPage += Array(pickedPictos.values)
            }
            .overlay(alignment: .top) {
                Button {
                    isPresented = false 
                } label: {
                    Text("Done")
                }
            }
        }
    }
}
