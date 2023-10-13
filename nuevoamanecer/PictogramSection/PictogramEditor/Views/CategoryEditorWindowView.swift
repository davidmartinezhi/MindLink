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
    @State var isDeletingCat: Bool = false
    
    @ObservedObject var pictoVM: PictogramViewModel
    @ObservedObject var catVM: CategoryViewModel
    
    @Binding var pickedCategoryId: String
    @Binding var searchText: String
    
    @State var showErrorMessage: Bool = false
    
    @State var DBActionInProgress: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    init(catModel: CategoryModel, pictoVM: PictogramViewModel, catVM: CategoryViewModel, pickedCategoryId: Binding<String>, searchText: Binding<String>){
        self.isNewCat = catModel.id == nil
        self._catModel = State(initialValue: catModel)
        self.catModelCapture = catModel
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
                .overlay(alignment: .leading) {
                    if !isNewCat {
                        let ovColor: Color = Color(red: 0.5, green: 0, blue: 0)
                        LongPressButtonWithImage(text: "Eliminar", width: 110, background: .red, overlayedBackground: ovColor, systemNameImage: "trash") {
                            isDeletingCat = true 
                        }
                    }
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
                        //Cancel
                        Button(action: {
                            dismiss()
                        }){
                            HStack {
                                Text("Cancelar")
                                    .font(.headline)
                                
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        
                        let addButtonIsDisabled: Bool = !catModel.isValidCateogry() || catModel.isEqualTo(catModelCapture) || catsWithSimilarColor.count > 0
                        //Save
                        Button(action: {
                            DBActionInProgress = true
                            if isNewCat {
                                catVM.addCat(catModel: catModel){ error, docId in
                                    if error != nil {
                                        showErrorMessage = true
                                    } else {
                                        searchText = ""
                                        pickedCategoryId = docId ?? ""
                                        dismiss()
                                    }
                                }
                            } else {
                                catVM.editCat(catId: catModel.id!, catModel: catModel){ error in
                                    if error != nil {
                                        showErrorMessage = true
                                    } else {
                                        dismiss()
                                    }
                                }
                            }

                        }) {
                            HStack {
                                Text("Guardar")
                                    .font(.headline)
                                
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(addButtonIsDisabled)
                        .allowsHitTesting(!DBActionInProgress)

                    
                    /*
                    
                    ButtonWithImageView(text: "Cancelar", systemNameImage: "xmark.circle.fill", background: .gray) {
                        dismiss()
                    }
                                        

                   
                    ButtonWithImageView(text: "Guardar", systemNameImage: "arrow.right.circle.fill", isDisabled: addButtonIsDisabled){
                        DBActionInProgress = true
                        if isNewCat {
                            catVM.addCat(catModel: catModel){ error, docId in
                                if error != nil {
                                    showErrorMessage = true
                                } else {
                                    searchText = ""
                                    pickedCategoryId = docId ?? ""
                                    dismiss()
                                }
                            }
                        } else {
                            catVM.editCat(catId: catModel.id!, catModel: catModel){ error in
                                if error != nil {
                                    showErrorMessage = true
                                } else {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .allowsHitTesting(!DBActionInProgress)
                                        
                    Spacer()
                     */
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 50)
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.white)
        }
        .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage)
        .customConfirmAlert(title: "Confirmar Eliminación", message: "La categoría y sus pictogramas serán eliminados para siempre.", isPresented: $isDeletingCat) {
            var pictoDeletionSucceeded: Bool = true
            
            if pictoVM.getNumPictosInCat(catId: catModel.id!) > 0 {
                pictoVM.removeAllPictosFrom(catId: catModel.id!) { error in
                    if error != nil {
                        // Los pictogramas de la categoría a eliminar no fueron eliminados.
                        pictoDeletionSucceeded = false
                    }
                }
            }
                
            if pictoDeletionSucceeded {
                catVM.removeCat(catId: catModel.id!) { error in
                    if error != nil {
                        // Los pictogramas de la categoría fueron eliminados, pero la categoría en sí no.
                        showErrorMessage = true
                    } else {
                        pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
                        dismiss()
                    }
                }
            } else {
                showErrorMessage = true 
            }
        }
    }
}
