//
//  PictogramEditorWindowView.swift
//  Comunicador
//
//  Created by emilio on 31/05/23.
//

import SwiftUI

struct PictogramEditorWindowView: View {
    @State var pictoModel: PictogramModel
    let pictoModelCapture: PictogramModel
    var isNewPicto: Bool
    @Binding var isEditingPicto: Bool
    
    @ObservedObject var pictoVM: PictogramViewModel
    @ObservedObject var catVM: CategoryViewModel
    
    @State var showErrorMessage: Bool = false
    
    init(pictoModel: PictogramModel?, isNewPicto: Bool, isEditingPicto: Binding<Bool>, pictoVM: PictogramViewModel, catVM: CategoryViewModel){
        _pictoModel = State(initialValue: pictoModel ?? PictogramModel.defaultPictogram())
        self.pictoModelCapture = pictoModel ?? PictogramModel.defaultPictogram()
        self.isNewPicto = isNewPicto
        _isEditingPicto = isEditingPicto
        self.pictoVM = pictoVM
        self.catVM = catVM
    }
    
    var body: some View {
        let currCat: CategoryModel? = catVM.getCat(catId: pictoModel.categoryId)
        
        GeometryReader { geo in
            VStack(spacing: 30) {
                HStack{
                    Spacer()
                    Text(isNewPicto ? "Nuevo Pictograma" : pictoModelCapture.name)
                        .font(.system(size: 30, weight: .bold))
                    Spacer()
                }
                
                HStack(spacing: 30) {
                    VStack {
                        PictogramView(pictoModel: $pictoModel.wrappedValue, catModel: currCat ?? CategoryModel.defaultCategory(),  displayName: true, displayCatColor: true)
                            .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.4)
                    }
                                        
                    VStack(alignment: .leading) {
                        Text("Nombre" + (pictoModel.name == pictoModelCapture.name ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        MiscTextFieldView(fieldWidth: geo.size.width * 0.3, placeHolder: "Nombre", inputText: $pictoModel.name)
                        
                        Text("Imagen" + (pictoModel.imageUrl == pictoModelCapture.imageUrl ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        MiscTextFieldView(fieldWidth: geo.size.width * 0.3, placeHolder: "Imagen", inputText: $pictoModel.imageUrl)

                        Text("Categoría" + (pictoModel.categoryId == pictoModelCapture.categoryId ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        DropDownCategoryPicker(categoryModels: catVM.getCats(), pickedCategoryId: $pictoModel.categoryId)
                    }
                }
                
                MiscButtonView(text: "Guardar", color: pictoModel.isValidPictogram() ? .blue : .gray) {
                    if isNewPicto {
                        pictoVM.addPicto(pictoModel: $pictoModel.wrappedValue) {error in
                            if error != nil {
                                showErrorMessage = true
                            } else {
                                isEditingPicto = false
                            }
                        }
                    } else {
                        pictoVM.editPicto(pictoId: pictoModel.id!, pictoModel: $pictoModel.wrappedValue) {error in
                            if error != nil {
                                showErrorMessage = true
                            } else {
                                isEditingPicto = false
                            }
                        }
                    }
                }
                .disabled(!pictoModel.isValidPictogram() || pictoModel.isEqualTo(pictoModelCapture))
    
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.white)
            .border(.black, width: 5)
            .overlay(alignment: .topLeading) {
                Button {
                    isEditingPicto = false
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
}
