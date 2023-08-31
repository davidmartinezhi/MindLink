//
//  CategoryEditorWindowView.swift
//  Comunicador
//
//  Created by emilio on 04/06/23.
//

import SwiftUI

struct CategoryEditorWindowView: View {
    @State var catModel: CategoryModel
    let catModelCapture: CategoryModel
    let isNewCat: Bool
    @Binding var isEditingCat: Bool
    
    @ObservedObject var pictoVM: PictogramViewModel
    @ObservedObject var catVM: CategoryViewModel
    
    @Binding var pickedCategoryId: String
    @Binding var searchText: String
    
    @State var showErrorMessage: Bool = false
    
    @State var DBActionInProgress: Bool = false
    
    init(catModel: CategoryModel?, isEditingCat: Binding<Bool>, pictoVM: PictogramViewModel, catVM: CategoryViewModel, pickedCategoryId: Binding<String>, searchText: Binding<String>){
        self.isNewCat = catModel == nil 
        self._catModel = State(initialValue: catModel ?? CategoryModel.defaultCategory())
        self.catModelCapture = catModel ?? CategoryModel.defaultCategory()
        self._isEditingCat = isEditingCat
        self.pictoVM = pictoVM
        self.catVM = catVM
        self._pickedCategoryId = pickedCategoryId
        self._searchText = searchText
    }
    
    var body: some View {
        let catsWithSimilarColor: [CategoryModel] = catVM.getCatsWithSimilarColor(catModel: catModel)
        
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 20){
                HStack {
                    Spacer()
                    
                    Text(isNewCat ? "Nueva Categoría" : catModelCapture.name)
                        .font(.system(size: 35, weight: .bold))
                        .padding()
                        .foregroundColor(ColorMaker.buildforegroundTextColor(catColor: catModelCapture.color))
                        .background(catModelCapture.buildColor())
                        .cornerRadius(10)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Nombre" + (catModel.name == catModelCapture.name ? "" : " *"))
                        .font(.system(size: 20, weight: .bold))
                    
                    TextFieldView(fieldWidth: geo.size.width * 0.4, placeHolder: "Nombre de la categoría", inputText: $catModel.name)
                }
                
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        Text("Color" + (catModel.color.isEqualTo(catModelCapture.color) ? "" : " *"))
                            .font(.system(size: 20, weight: .bold))
                        
                        if catsWithSimilarColor.count > 0 {
                            HStack(spacing: 5) {
                                let similarCatModel: CategoryModel = catsWithSimilarColor.first!
                                Text("La categoría")
                                Text("\(similarCatModel.name)")
                                    .background(similarCatModel.buildColor())
                                    .foregroundColor(ColorMaker.buildforegroundTextColor(catColor: similarCatModel.color))
                                Text("tiene un color similar.")
                            }
                        }
                    }
                    
                    ColorPickerView(red: $catModel.color.r, green: $catModel.color.g, blue: $catModel.color.b)
                        .frame(height: 280)
                }
                
                HStack {
                    Spacer()
                    
                    ButtonWithImageView(text: "Cancelar", systemNameImage: "xmark.circle.fill", background: .gray) {
                        isEditingCat = false
                    }
                                        
                    if !isNewCat {
                        let removeButtonIsDisabled: Bool = catModel.name != catModelCapture.name || pictoVM.getNumPictosInCat(catId: catModel.id ?? "") > 0
                        ButtonWithImageView(text: "Eliminar", systemNameImage: "trash", background: .red, isDisabled: removeButtonIsDisabled){
                            catVM.removeCat(catId: catModel.id!){ error in
                                if error != nil  {
                                    showErrorMessage = true
                                } else {
                                    pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
                                    isEditingCat = false
                                }
                            }
                        }
                    }
                    
                    let addButtonIsDisabled: Bool = !catModel.isValidCateogry() || catModel.isEqualTo(catModelCapture) || catsWithSimilarColor.count > 0
                    ButtonWithImageView(text: "Guardar", systemNameImage: "arrow.right.circle.fill", isDisabled: addButtonIsDisabled){
                        DBActionInProgress = true
                        if isNewCat {
                            catVM.addCat(catModel: catModel){ error, docId in
                                if error != nil {
                                    showErrorMessage = true
                                } else {
                                    searchText = ""
                                    pickedCategoryId = docId ?? ""
                                    isEditingCat = false
                                }
                            }
                        } else {
                            catVM.editCat(catId: catModel.id!, catModel: catModel){ error in
                                if error != nil {
                                    showErrorMessage = true
                                } else {
                                    isEditingCat = false
                                }
                            }
                        }
                    }
                    .allowsHitTesting(!DBActionInProgress)
                                        
                    Spacer()
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 50)
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.white)
            .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage)
        }
    }
}
