//
//  PageCreationView.swift
//  nuevoamanecer
//
//  Created by emilio on 24/06/23.
//

import SwiftUI

struct PageCreationView: View {
    @Binding var isCreatingNewPage: Bool
    @ObservedObject var pageVM: PageViewModel
    @State var pageModel: PageModel = PageModel.defaultPage()
    var width: CGFloat = 400
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Nueva Hoja")
                .font(.system(size: 40, weight: .bold))
            
            TextFieldView(fieldWidth: width * 0.9, placeHolder: "Nombre de la página", inputText:  $pageModel.name)
            
            HStack() {
                let buttonWidth: CGFloat = (width * 0.9) * 0.4
                
                ButtonWithImageView(text: "Cancelar", width: buttonWidth,systemNameImage: "xmark"){
                    isCreatingNewPage = false
                }
                
                ButtonWithImageView(text: "Crear", width: buttonWidth, systemNameImage: "checkmark") {
                    pageVM.addPage(pageModel: pageModel) { error in
                        if error != nil {
                            // Error
                        } else {
                            isCreatingNewPage = false
                        }
                    }
                }
            }
        }
        .padding(.vertical, 30)
        .frame(width: width)
        .background(.white)
        .cornerRadius(10)
    }
}

