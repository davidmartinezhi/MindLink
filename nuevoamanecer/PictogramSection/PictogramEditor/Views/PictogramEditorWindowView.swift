//
//  PictogramEditorWindowView.swift
//  Comunicador
//
//  Created by emilio on 31/05/23.
//

import SwiftUI

func buildImageName(catName: String, pictoName: String) -> String {
    let newCatName = catName.replacingOccurrences(of: " ", with: "")
    let newPictoName = pictoName.replacingOccurrences(of: " ", with: "")
    
    return newCatName + "_" + newPictoName + "_" + UUID().uuidString
}

struct PictogramEditorWindowView: View {
    @State var pictoModel: PictogramModel
    let pictoModelCapture: PictogramModel
    @Binding var isNewPicto: Bool
    @Binding var isEditingPicto: Bool
    
    @ObservedObject var pictoVM: PictogramViewModel
    @ObservedObject var catVM: CategoryViewModel
    
    @Binding var pickedCategoryId: String
    @Binding var searchText: String 
    
    @State var showErrorMessage: Bool = false
    
    @State private var showImagePicker: Bool = false
    @State var temporaryUIImage: UIImage? = nil
    var imageHandler: FirebaseAlmacenamiento = FirebaseAlmacenamiento()
    
    @State var DBActionInProgress: Bool = false
            
    init(pictoModel: PictogramModel?, isNewPicto: Binding<Bool>, isEditingPicto: Binding<Bool>, pictoVM: PictogramViewModel, catVM: CategoryViewModel, pickedCategoryId: Binding<String>, searchText: Binding<String>){
        self._pictoModel = State(initialValue: pictoModel ?? PictogramModel.defaultPictogram(catId: pickedCategoryId.wrappedValue))
        self.pictoModelCapture = pictoModel ?? PictogramModel.defaultPictogram(catId: pickedCategoryId.wrappedValue)
        self._isNewPicto = isNewPicto
        self._isEditingPicto = isEditingPicto
        self.pictoVM = pictoVM
        self.catVM = catVM
        self._pickedCategoryId = pickedCategoryId
        self._searchText = searchText
    }
    
    var body: some View {
        let currCat: CategoryModel? = catVM.getCat(catId: pictoModel.categoryId)
        
        GeometryReader { geo in
            VStack(spacing: 30) {
                Text(isNewPicto ? "Nuevo Pictograma" : pictoModelCapture.name)
                    .font(.system(size: 35, weight: .bold))

                HStack(spacing: 30) {
                    PictogramView(pictoModel: $pictoModel.wrappedValue, catModel: currCat ?? CategoryModel.defaultCategory(),  displayName: true, displayCatColor: true, temporaryUIImage: temporaryUIImage)
                        .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.4)
                                        
                    VStack(alignment: .leading) {
                        Text("Nombre" + (pictoModel.name == pictoModelCapture.name ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        
                        TextFieldView(fieldWidth: geo.size.width * 0.3, placeHolder: "Nombre", inputText: $pictoModel.name)
                        
                        Text("Imagen" + (temporaryUIImage == nil ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: temporaryUIImage == nil ? "arrow.up.square" : "checkmark")
                                    .foregroundColor(temporaryUIImage == nil ? .white : .green)
                                Text(temporaryUIImage == nil ? "Subir una imagen" : "Subir otra imagen")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                        }
                        
                        Text("Categoría" + (pictoModel.categoryId == pictoModelCapture.categoryId ? "" : "*"))
                            .font(.system(size: 20, weight: .bold))
                        DropDownCategoryPicker(categoryModels: catVM.getCats(), pickedCategoryId: $pictoModel.categoryId, pickedCatModel: catVM.getCat(catId: pictoModel.categoryId), itemWidth: geo.size.width * 0.3)
                    }
                }
                
                HStack {
                    
                    //Cancel
                    ButtonWithImageView(text: "Cancelar", systemNameImage: "xmark.circle.fill", background: .gray) {
                        isEditingPicto = false
                    }
                    
                    // Save
                    let saveButtonIsDisabled: Bool = !(pictoModel.isValidPictogram() && !pictoModel.isEqualTo(pictoModelCapture) && (temporaryUIImage != nil || !pictoModel.imageUrl.isEmpty))
                    ButtonWithImageView(text: "Guardar", systemNameImage: "arrow.right.circle.fill", isDisabled: saveButtonIsDisabled) {
                        DBActionInProgress = true
                        Task {
                            if temporaryUIImage != nil {
                                let imageName: String = buildImageName(catName: catVM.getCat(catId: pictoModel.categoryId)!.name, pictoName: pictoModel.name)
                                if let downloadUrl: URL = await imageHandler.uploadImage(image: temporaryUIImage!, name: imageName){
                                    self.pictoModel.imageUrl = downloadUrl.absoluteString
                                } else {
                                    // Error al subir imagen.
                                }
                            }
                            
                            if isNewPicto {
                                pictoVM.addPicto(pictoModel: self.pictoModel) {error in
                                    if error != nil {
                                        showErrorMessage = true
                                    } else {
                                        searchText = ""
                                        pickedCategoryId = pictoModel.categoryId
                                        isEditingPicto = false
                                    }
                                }
                            } else {
                                pictoVM.editPicto(pictoId: self.pictoModel.id!, pictoModel: self.pictoModel) {error in
                                    if error != nil {
                                        showErrorMessage = true
                                    } else {
                                        isEditingPicto = false
                                    }
                                }
                            }
                        }
                    }
                    .allowsHitTesting(!DBActionInProgress)
                }
            }
            .padding()
            .frame(width: geo.size.width, height: geo.size.height)
            .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage) // Definir error
            .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
                ImagePicker(image: $temporaryUIImage)
            }
        }
    }
}
