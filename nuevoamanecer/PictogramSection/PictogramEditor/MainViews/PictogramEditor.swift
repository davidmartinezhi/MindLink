//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

// Importamos SwiftUI
import SwiftUI

// Definimos el struct PictogramEditor que cumple con el protocolo View
struct PictogramEditor: View {
    // Inicializamos los objetos que manejarán los pictogramas y las categorías
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    // Estados de la interfaz gráfica
    @State var searchText: String = "" // Texto de búsqueda
    @State var pickedCategoryId: String = "" // ID de la categoría seleccionada
    @State var isDeleting: Bool = false // Estado de eliminación
    @State var isNewPicto: Bool = false // Si se está creando un nuevo pictograma
    @State var isNewCat: Bool = false // Si se está creando una nueva categoría
    @State var pictoBeingEdited: PictogramModel? = nil // Pictograma que se está editando
    @State var catBeingEdited: CategoryModel? = nil // Categoría que se está editando
    @State var isEditingPicto: Bool = false // Si se está editando un pictograma
    @State var isEditingCat: Bool = false // Si se está editando una categoría
    @State var showErrorMessage: Bool = false // Si se muestra un mensaje de error
    @State var userHasChosenCat: Bool = false // Si el usuario ha seleccionado una categoría
    
    // Handler para las imágenes en Firebase
    var imageHandler: FirebaseAlmacenamiento = FirebaseAlmacenamiento()

    // Inicializador del PictogramEditor
    init(pictoCollectionPath: String, catCollectionPath: String){
        // Inicializamos los ViewModel con los paths correspondientes
        _pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        _catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
    }
    
    // Cuerpo de la vista
    var body: some View {
        // Obtenemos la categoría actual y los pictogramas correspondientes
        let currCat: CategoryModel? = catVM.getCat(catId: pickedCategoryId)
        let pictosInScreen: [PictogramModel] = searchText.isEmpty ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    // Barra superior con botones para eliminar y agregar pictogramas
                    HStack {
                        
                        SearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                        Spacer()
                        
                        /*
                        ButtonView(text: isDeleting ?  "Cancelar" : "Eliminar Pictograma", color: isDeleting ? .gray : .red, isDisabled: pictosInScreen.count == 0) {
                            isDeleting.toggle()
                        }
                         */
                        
                        
                        Button(action: {
                            isDeleting.toggle()
                        }){
                            HStack{
                                if(isDeleting){
                                    Text("Cancelar")
                                        .font(.headline)
                                }else{
                               
                                    Text("Eliminar Pictograma")
                                        .font(.headline)
                                }
                            }
                        }
                        .padding(10)
                        .background(isDeleting ? .gray : .red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .allowsHitTesting(pictosInScreen.count > 0)
                        

                        
                        
                        let noCategories: Bool = catVM.getCats().count == 0
                        
                        /*
                        ButtonView(text: noCategories ? "Crea una categoría" : "Agregar Pictograma", color: .blue, isDisabled: noCategories) {
                            isNewPicto = true
                            pictoBeingEdited = nil
                            isEditingPicto = true
                        }
                        */
                        
                        Button(action: {
                            isNewPicto = true
                            pictoBeingEdited = nil
                            isEditingPicto = true
                        }){
                            HStack{
                                if(noCategories){
                                   
                                    Text("Crea una categoria")
                                        .font(.headline)
                                }else{
                                    
                                    Text("Agregar Pictograma")
                                        .font(.headline)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .allowsHitTesting(!noCategories)
                        
                    }
                    .frame(height: 40)
                    .padding(.vertical)
                    .padding(.horizontal, 70)
                    //.background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    // Barra de búsqueda, selector de categoría y botones para editar y agregar categorías
                    HStack(spacing: 15) {
                        
                        Text("Categorias")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.gray)
                        
                        HStack{
                            //CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                           // let editCatButtonsColor: Color = currCat != nil ? ColorMaker.buildforegroundTextColor(catColor: currCat!.color) : .black
                            let editCatButtonisDisabled: Bool = pickedCategoryId.isEmpty || catVM.getCat(catId: pickedCategoryId) == nil
                            
                            /*
                            Button { // Botón para editar
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
                             */
                            
                            
                            //Editar categoria
                            Button(action: {
                                isNewCat = false
                                catBeingEdited = catVM.getCat(catId: pickedCategoryId)
                                isEditingCat = true
                            }) {
                                HStack {
                                    Text("Editar")
                                        .font(.headline)
                                }
                            }
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .allowsHitTesting(!editCatButtonisDisabled)
                            
                            //Agregar categoria
                            Button(action: {
                                isNewCat = true
                                catBeingEdited = nil
                                isEditingCat = true
                            }) {
                                HStack {
                                    Text("Agregar")
                                        .font(.headline)
                                }
                            }
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            /*
                            Button { // Botón para agregar
                                isNewCat = true
                                catBeingEdited = nil
                                isEditingCat = true
                            } label: {
                                
                                HStack{
                                    
                                }
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                                    .foregroundColor(editCatButtonsColor)
                            }
                            */
                        }
                        //.background(currCat?.buildColor() ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                        .padding([.leading, .top, .bottom])
                        .padding(.trailing, 20)
                        
                        Divider()
                        
                        CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                       
                       

                    }
                    .frame(maxHeight: 60)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 70)
                    //.background(currCat?.buildColor() ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    /*.overlay(alignment: .bottom) {
                        Rectangle()
                            .frame(width: geo.size.width, height: 0.5)
                            .foregroundColor(.black)
                    }*/
                   
                    Rectangle()
                        .frame(height: 20.0, alignment: .bottom)
                        .foregroundColor(currCat?.buildColor() ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    // Cuadrícula de pictogramas
                    PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 165, pictoHeight: 165)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Si se está editando un pictograma o una categoría, se muestra la vista de edición correspondiente
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
            .customAlert(title: "Error", message: "Error", isPresented: $showErrorMessage) // Alerta de error
        }
        // Si la categoría seleccionada es nula o no ha sido elegida por el usuario, seleccionamos la primera categoría
        .onReceive(catVM.objectWillChange) { _ in
             if pickedCategoryId.isEmpty || !userHasChosenCat {
                 pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
             }
         }
    }
    
    // Función que construye los botones de los pictogramas
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    if isDeleting == true {
                        Task {
                            if !pictoModel.imageUrl.isEmpty {
                                _  = await imageHandler.deleteImage(donwloadUrl: pictoModel.imageUrl)
                            }
                            pictoVM.removePicto(pictoId: pictoModel.id!) { error in
                                if error != nil {
                                    showErrorMessage = true
                                } else {
                                    isDeleting = false
                                }
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
