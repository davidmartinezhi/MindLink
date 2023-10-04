//
//  EditPanelView.swift
//  nuevoamanecer
//
//  Created by emilio on 29/09/23.
//

import SwiftUI

struct EditPanelView: View {
    var isBeingEdited: Bool
    var isNewUser: Bool
    var disableSave: Bool 
    var runAtEdit: ()->Void
    var runAtDelete: ()->Void
    var runAtSave: ()->Void
    var runAtCancel: ()->Void
    
    var body: some View {
        if isBeingEdited {
            isBeingEditedPanel
        } else {
            isNotBeingEditedPanel
        }
    }
    
    var isNotBeingEditedPanel: some View {
        HStack(spacing: 40){
            let iconWidth: CGFloat = 25

            Button {
                runAtEdit()
            } label: {
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconWidth)
            }
            
            Button {
                runAtDelete()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconWidth)
            }
        }
    }
    
    var isBeingEditedPanel: some View {
        VStack(spacing: 10) {
            ButtonWithImageView(text: "Guardar", width: 150, systemNameImage: "square.and.arrow.down", isDisabled: disableSave){
                runAtSave()
            }
            
            ButtonWithImageView(text: "Cancelar", width: 150, systemNameImage: "xmark", background: .red){
                runAtCancel()
            }
        }
    }
}
