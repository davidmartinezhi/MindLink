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
    @ObservedObject var boardCache: BoardCache
    
    @State var pickingPictograms: Bool = false
    
    @State var pageId: String?
    
    @Environment(\.dismiss) private var dismiss
    
    init(patientId: String, pageVM: PageViewModel, pageModel: PageModel, boardCache: BoardCache){
        self.patientId = patientId
        self.pageVM = pageVM
        _pageModel = State(initialValue: pageModel)
        _pageModelCapture = State(initialValue: pageModel)
        self.boardCache = boardCache
        _pageId = State(initialValue: pageModel.id)
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 15) {
                    TextFieldView(fieldWidth: geo.size.width * 0.3, placeHolder: pageModelCapture.name, inputText: $pageModel.name, maxCharLength: 25) // 25: número máximo de caracteres que el nombre de la página puede tener. 
                    
                    Spacer()
                    
                    ButtonWithImageView(text: "Agregar pictogramas", systemNameImage: "plus") {
                        pickingPictograms = true
                    }
                    
                    let pageHasChanged: Bool = pageModelCapture != pageModel
                    ButtonWithImageView(text: pageHasChanged || pageId == nil ? "Guardar" : "Guardado", systemNameImage: pageHasChanged || pageId == nil ? "square.and.arrow.down" : "checkmark", isDisabled: !(pageHasChanged || pageId == nil)) {
                        if pageId == nil {
                            pageVM.addPage(pageModel: pageModel) { error, docId in
                                if error != nil {
                                    // Error
                                } else if docId == nil {
                                    dismiss()
                                } else {
                                    pageId = docId!
                                    pageModelCapture = pageModel
                                }
                            }
                        } else {
                            pageVM.editPage(pageId: pageId!, pageModel: pageModel){ error in
                                if error != nil {
                                    // Error
                                } else {
                                    pageModelCapture = pageModel
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Divider()
                
                PageBoardView(pageModel: $pageModel, boardCache: boardCache, pictoBaseWidth: 200, pictoBaseHeight: 200, isEditing: true)
            }
            .onChange(of: pickingPictograms) { _ in
                Task {
                    await boardCache.populateBoard(pictosInPage: pageModel.pictogramsInPage)
                }
            }
        }
        .fullScreenCover(isPresented: $pickingPictograms) {
            DoublePictogramPickerView(pageModel: $pageModel, isPresented: $pickingPictograms, pictoCollectionPath1: "basePictograms", catCollectionPath1: "baseCategories", pictoCollectionPath2: "User/\(patientId)/pictograms", catCollectionPath2: "User/\(patientId)/categories")
        }
        .onAppear {
            if pageId != nil {
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
}
