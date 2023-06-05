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
    var isNewCat: Bool
    @Binding var isEditingCat: Bool
    
    @ObservedObject var pictoVM: PictogramViewModel
    @ObservedObject var catVM: CategoryViewModel
    
    @State var showErrorMessage: Bool = false
    
    init(catModel: CategoryModel?, isNewCat: Bool, isEditingCat: Binding<Bool>, pictoVM: PictogramViewModel, catVM: CategoryViewModel){
        _catModel = State(initialValue: catModel ?? CategoryModel.defaultCategory())
        self.catModelCapture = catModel ?? CategoryModel.defaultCategory()
        self.isNewCat = isNewCat
        _isEditingCat = isEditingCat
        self.pictoVM = pictoVM
        self.catVM = catVM
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Spacer()
                Text(isNewCat ? "Nueva Categoría" : catModelCapture.name)
                    .font(.system(size: 30, weight: .bold))
                Spacer()
            }
            
            VStack(alignment: .leading) {
                Text("Nombre" + (catModel.name == catModelCapture.name ? "" : " *"))
                    .font(.system(size: 20, weight: .bold))
                MiscTextFieldView(fieldWidth: 200, placeHolder: "Categoría", inputText: $catModel.name)
            }
            
            VStack(alignment: .leading) {
                Text("Color" + (catModel.color.isEqualTo(catModelCapture.color) ? "" : " *"))
                    .font(.system(size: 20, weight: .bold))
                MiscColorPickerView(red: $catModel.color.r, green: $catModel.color.g, blue: $catModel.color.b)
                    .frame(height: 200)
            }
            
            HStack {
                Spacer()
                if !isNewCat && catModel.name == catModelCapture.name && pictoVM.getNumPictosInCat(catId: catModel.id ?? "") == 0 {
                    MiscButtonView(text: "Eliminar", color: .red){
                        catVM.removeCat(catId: catModel.id!){ error in
                            if error != nil  {
                                showErrorMessage = true
                            } else {
                                isEditingCat = false
                            }
                        }
                    }
                }
                
                MiscButtonView(text: "Guardar", color: .blue){
                    if isNewCat {
                        catVM.addCat(catModel: catModel){ error in
                            if error != nil {
                                showErrorMessage = true
                            } else {
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
                .disabled(!catModel.isValidCateogry() || catModel.isEqualTo(catModelCapture))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 50)
        .padding(.vertical, 100)
        .background(.white)
        .border(.black, width: 5)
        .overlay(alignment: .topLeading) {
            Button {
                isEditingCat = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .foregroundColor(.black)
                    .padding(40)
            }
        }
        .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage)
    }
}
