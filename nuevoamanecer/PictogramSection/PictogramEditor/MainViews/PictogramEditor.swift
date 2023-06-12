//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramEditor: View {
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isDeleting: Bool = false
    
    @State var isNewPicto: Bool = false
    @State var isNewCat: Bool = false
    @State var pictoBeingEdited: PictogramModel? = nil
    @State var catBeingEdited: CategoryModel? = nil
    @State var isEditingPicto: Bool = false
    @State var isEditingCat: Bool = false
    
    @State var showErrorMessage: Bool = false
    
    @State var userHasChosenCat: Bool = false
    
    init(pictoCollectionPath: String, catCollectionPath: String){
        _pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        _catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
    }
        
    var body: some View {
        let currCat: CategoryModel? = catVM.getCat(catId: pickedCategoryId)
        let pictosInScreen: [PictogramModel] = searchText.isEmpty ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        ButtonView(text: "Regresar", color: .blue) {}
                        
                        Spacer()
                        
                        ButtonView(text: isDeleting ?  "Cancelar" : "Eliminar Pictograma", color: .red, isDisabled: pictosInScreen.count == 0) {
                            isDeleting.toggle()
                        }
                        
                        let noCategories: Bool = catVM.getCats().count == 0
                        ButtonView(text: noCategories ? "Crea una categoría" : "Agregar Pictograma", color: .blue, isDisabled: noCategories) {
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
                        SearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                        
                        CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                                                
                        let editCatButtonsColor: Color = currCat != nil ? ColorMaker.buildforegroundTextColor(catColor: currCat!.color) : .black
                        let editCatButtonisDisabled: Bool = pickedCategoryId.isEmpty || catVM.getCat(catId: pickedCategoryId) == nil
                        Button { // Editar
                            isNewCat = false
                            catBeingEdited = catVM.getCat(catId: pickedCategoryId)
                            isEditingCat = true
                        } label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .foregroundColor(editCatButtonsColor)
                                .overlay(alignment: .center) {
                                    if editCatButtonisDisabled{
                                        XOverCircleView(diameter: 20)
                                    }
                                }
                        }
                        .allowsHitTesting(!editCatButtonisDisabled)
                        
                        Button { // Agregar
                            isNewCat = true
                            catBeingEdited = nil
                            isEditingCat = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40)
                                .foregroundColor(editCatButtonsColor)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(currCat?.buildColor() ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .frame(width: geo.size.width, height: 0.5)
                            .foregroundColor(.black)
                    }
                    
                    PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 200, pictoHeight: 200)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if isEditingPicto || isEditingCat {
                    Button {
                        isEditingCat = false
                        isEditingPicto = false 
                    } label: {
                        Color(.gray)
                            .opacity(0.5)
                    }

                    if isEditingPicto {
                        PictogramEditorWindowView(pictoModel: pictoBeingEdited, isNewPicto: isNewPicto, isEditingPicto: $isEditingPicto, pictoVM: pictoVM, catVM: catVM, pickedCategoryId: $pickedCategoryId)
                            .frame(width: geo.size.width * 0.7, height: 600)
                    } else if isEditingCat {
                        CategoryEditorWindowView(catModel: catBeingEdited, isNewCat: isNewCat, isEditingCat: $isEditingCat, pictoVM: pictoVM, catVM: catVM, pickedCategoryId: $pickedCategoryId)
                            .frame(width: geo.size.width * 0.7)
                    }
                }
            }
            .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage) // Definir error
        }
        .onReceive(catVM.objectWillChange) { _ in
             if pickedCategoryId.isEmpty || !userHasChosenCat {
                 pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
             }
         }
    }
    
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    if isDeleting == true {
                        pictoVM.removePicto(pictoId: pictoModel.id!) { error in
                            if error != nil {
                                showErrorMessage = true
                            } else {
                                isDeleting = false
                            }
                        }
                    } else {
                        isNewPicto = false
                        pictoBeingEdited = pictoModel
                        isEditingPicto = true
                    }
                }, label: {
                    PictogramView(pictoModel: pictoModel,
                                  catModel: catVM.getCat(catId: pictoModel.categoryId)!,
                                  displayName: true,
                                  displayCatColor: false,
                                  overlayImage: isDeleting ? Image(systemName: "xmark.circle") : Image(systemName: "pencil"),
                                  overlayImageWidth: 0.2,
                                  overlayImageColor: isDeleting ? .red : .gray,
                                  overlyImageOpacity: isDeleting ? 1 : 0.2)
                })
            )
        }
        return pictoButtons
    }
}