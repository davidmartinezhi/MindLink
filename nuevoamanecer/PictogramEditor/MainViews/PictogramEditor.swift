//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI

struct PictogramEditor: View {
    @StateObject var userPictoVM: PictogramViewModel
    @StateObject var userCatVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isDeleting: Bool = false
    
    @State var isNewPicto: Bool = false
    @State var isNewCat: Bool = false
    @State var pictoBeingEdited: PictogramModel? = nil
    @State var catBeingEdited: CategoryModel? = nil
    @State var isEditingPicto: Bool = false
    @State var isEditingCat: Bool = false
    
    init(userId: String){
        _userPictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: "User/\(userId)/pictograms"))
        _userCatVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: "User/\(userId)/categories"))
    }

    var body: some View {
        let currCat: CategoryModel? = userCatVM.getCat(catId: pickedCategoryId)
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        ButtonView(text: "Regresar", color: .blue) {}
                        
                        Spacer()
                        
                        ButtonView(text: isDeleting ?  "Cancelar" : "Eliminar Pictograma", color: .red) {
                            isDeleting.toggle()
                        }
                        
                        ButtonView(text: "Agregar Pictograma", color: .blue) {
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
                        
                        CategoryPickerView(categoryModels: userCatVM.getCats(), pickedCategoryId: $pickedCategoryId)
                                                
                        let editCatButtonsColor: Color = currCat != nil ? ColorMaker.buildforegroundTextColor(catColor: currCat!.color) : .black
                        let editCatButtonisDisabled: Bool = pickedCategoryId.isEmpty || userCatVM.getCat(catId: pickedCategoryId) == nil
                        Button { // Editar
                            isNewCat = false
                            catBeingEdited = userCatVM.getCat(catId: pickedCategoryId)
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
                    
                    PictogramGridView(pictograms: buildPictoViewButtons(searchText.isEmpty ? userPictoVM.getPictosFromCat(catId: pickedCategoryId) :
                                                                            userPictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)),
                                      pictoWidth: 200, pictoHeight: 200)
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
                        PictogramEditorWindowView(pictoModel: pictoBeingEdited, isNewPicto: isNewPicto, isEditingPicto: $isEditingPicto, pictoVM: userPictoVM, catVM: userCatVM, pickedCategoryId: $pickedCategoryId)
                            .frame(width: geo.size.width * 0.7, height: 600)
                    } else if isEditingCat {
                        CategoryEditorWindowView(catModel: catBeingEdited, isNewCat: isNewCat, isEditingCat: $isEditingCat, pictoVM: userPictoVM, catVM: userCatVM, pickedCategoryId: $pickedCategoryId)
                            .frame(width: geo.size.width * 0.7)
                    }
                }
            }
        }
        .onReceive(userCatVM.objectWillChange) { _ in
            if pickedCategoryId.isEmpty {
                pickedCategoryId = userCatVM.getFirstCat()?.id! ?? ""
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
