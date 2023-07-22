//
//  PageEditView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageEdit: View {
    var patientId: String
    @ObservedObject var pageVM: PageViewModel
    @State var pageModel: PageModel
    @State var pageModelCapture: PageModel
    @ObservedObject var pictoCache: PictogramCache
    @ObservedObject var catCache: CategoryCache
    
    @State var pickingPictograms: Bool = false
    
    init(patientId: String, pageVM: PageViewModel, pageModel: PageModel, pictoCache: PictogramCache, catCache: CategoryCache){
        self.patientId = patientId
        self.pageVM = pageVM
        _pageModel = State(initialValue: pageModel)
        _pageModelCapture = State(initialValue: pageModel)
        self.pictoCache = pictoCache
        self.catCache = catCache
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 15) {
                    TextFieldView(fieldWidth: geo.size.width * 0.3, placeHolder: pageModelCapture.name, inputText: $pageModel.name)
                    
                    Spacer()
                    
                    ButtonWithImageView(text: "Agregar pictogramas", systemNameImage: "plus") {
                        pickingPictograms = true
                    }
                    
                    let pageHasChanged: Bool = pageModelCapture != pageModel
                    ButtonWithImageView(text: pageHasChanged ? "Guardar" : "Guardado", systemNameImage: pageHasChanged ? "square.and.arrow.down" : "checkmark", isDisabled: !pageHasChanged) {
                        pageVM.editPage(pageId: pageModel.id!, pageModel: pageModel){ error in
                            if error != nil {
                                // Error
                            } else {
                                pageModelCapture = pageModel
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Divider()
                
                PageBoardView(pageModel: $pageModel, pictoCache: pictoCache, catCache: catCache, isEditing: true, soundOn: false, pictoBaseWidth: 200, pictoBaseHeight: 200)
            }
        }
        .fullScreenCover(isPresented: $pickingPictograms) {
            DoublePictogramPickerView(pageModel: $pageModel, isPresented: $pickingPictograms, pictoCollectionPath1: "basePictograms", catCollectionPath1: "baseCategories", pictoCollectionPath2: "Patient/\(patientId)/pictograms", catCollectionPath2: "Patient/\(patientId)/categories")
        }
        .onAppear {
            pageVM.updatePageLastOpenedAt(pageId: pageModel.id!) { error in
                if error != nil {
                    // Error
                } else {
                    // Exito
                }
            }
        }
    }
}
