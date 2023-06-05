//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramEditor: View {
    // @StateObject var basePictoVM: PictogramViewModel = PictogramViewModel(collectionPath: "basePictograms")
    // @StateObject var baseCatVM: CategoryViewModel = CategoryViewModel(collectionPath: "baseCategories")
    // "users/user_id/pictograms"
    // "users/user_id/categories"
    @StateObject var userPictoVM: PictogramViewModel = PictogramViewModel(collectionPath: "basePictograms")
    @StateObject var userCatVM: CategoryViewModel = CategoryViewModel(collectionPath: "baseCategories") 
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isDeleting: Bool = false
    
    @State var isNewPicto: Bool = false
    @State var isNewCat: Bool = false
    @State var pictoBeingEdited: PictogramModel? = nil
    @State var catBeingEdited: CategoryModel? = nil
    @State var isEditingPicto: Bool = false
    @State var isEditingCat: Bool = false 
        
    var body: some View {
        let currCatColor: Color? = userCatVM.getCat(catId: pickedCategoryId)?.buildColor()
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        MiscButtonView(text: "Regresar", color: .blue) {}
                        
                        Spacer()
                        
                        MiscButtonView(text: isDeleting ?  "Cancelar" : "Eliminar Pictograma", color: .red) {
                            isDeleting.toggle()
                        }
                        
                        MiscButtonView(text: "Agregar Pictograma", color: .blue) {
                            isNewPicto = true
                            pictoBeingEdited = nil
                            isEditingPicto = true
                        }
                    }
                    .frame(height: 40)
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    HStack(spacing: 25) {
                        MiscSearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                        
                        CategoryPickerView(categoryModels: userCatVM.getCats(), pickedCategoryId: $pickedCategoryId)
                        
                        Spacer()
                        
                        Button { // Editar
                            isNewCat = false
                            catBeingEdited = userCatVM.getCat(catId: pickedCategoryId)
                            isEditingCat = true
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                        }
                        .disabled(pickedCategoryId.isEmpty)
                        
                        Button { // Agregar
                            isNewCat = true
                            catBeingEdited = nil
                            isEditingCat = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                        }
                    }
                    
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(currCatColor ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    PictogramGridView(pictograms: buildPictoViewButtons(searchText.isEmpty ? userPictoVM.getPictosFromCat(catId: pickedCategoryId) :
                                                                            userPictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)),
                                      pictoWidth: 200, pictoHeight: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if isEditingPicto || isEditingCat {
                    Color(.gray)
                        .opacity(0.5)
                    
                    if isEditingPicto {
                        PictogramEditorWindowView(pictoModel: pictoBeingEdited, isNewPicto: isNewPicto, isEditingPicto: $isEditingPicto, pictoVM: userPictoVM, catVM: userCatVM)
                            .frame(width: geo.size.width * 0.7, height: 600)
                    } else if isEditingCat {
                        CategoryEditorWindowView(catModel: catBeingEdited, isNewCat: isNewCat, isEditingCat: $isEditingCat, pictoVM: userPictoVM, catVM: userCatVM)
                            .frame(width: geo.size.width * 0.7)
                    }
                }
            }
        }
    }
    
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    if isDeleting == true {
                        userPictoVM.removePicto(pictoId: pictoModel.id!) { error in
                        }
                    } else {
                        isNewPicto = false
                        pictoBeingEdited = pictoModel
                        isEditingPicto = true
                    }
                }, label: {
                    PictogramView(pictoModel: pictoModel,
                                  catModel: userCatVM.getCat(catId: pictoModel.categoryId)!,
                                  displayName: true,
                                  displayCatColor: false,
                                  overlayImage: isDeleting ? Image(systemName: "xmark.circle") : nil)
                })
            )
        }
        return pictoButtons
    }
}
