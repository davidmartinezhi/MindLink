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
    let patient: Patient?
    
    // Inicializamos los objetos que manejarán los pictogramas y las categorías
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    // Estados de la interfaz gráfica
    @State var searchText: String = "" // Texto de búsqueda
    @State var searchingPicto: Bool = true
    @State var pickedCategoryId: String = "" // ID de la categoría seleccionada
    
    @State var isDeleting: Bool = false // Estado de eliminación
    @State var showDeleteAlert: Bool = false
    @State var pictoModelToDelete: PictogramModel? = nil
    @State var pictoBeingEdited: PictogramModel? = nil // Pictograma que se está editando
    @State var catBeingEdited: CategoryModel? = nil // Categoría que se está editando
    @State var isEditingPicto: Bool = false // Si se está editando un pictograma
    @State var isEditingCat: Bool = false // Si se está editando una categoría
    @State var showErrorMessage: Bool = false // Si se muestra un mensaje de error
    @State var userHasChosenCat: Bool = false // Si el usuario ha seleccionado una categoría
    
    // Handler para las imágenes en Firebase
    var imageHandler: FirebaseAlmacenamiento = FirebaseAlmacenamiento()

    // Inicializador del PictogramEditor
    init(patient: Patient?){
        self.patient = patient
        let pictoCollectionPath: String = patient != nil ? "User/\(patient!.id)/pictograms" : "basePictograms"
        let catCollectionPath: String = patient != nil ? "User/\(patient!.id)/categories" : "baseCategories"
        
        // Inicializamos los ViewModel con los paths correspondientes
        self._pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        self._catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
    }
    
    // Cuerpo de la vista
    var body: some View {
        // Obtenemos la categoría actual y los pictogramas correspondientes
        let currCat: CategoryModel? = catVM.getCat(catId: pickedCategoryId)
        let pictosInScreen: [PictogramModel] = searchText.isEmpty || !searchingPicto ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        let catsInScreen: [CategoryModel] = searchText.isEmpty || searchingPicto ? catVM.getCats() : catVM.getCats(nameFilter: searchText)
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Barra superior con botones para eliminar y agregar pictogramas
                HStack {
                    PictogramSearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.25, searchingPicto: $searchingPicto)
                        .onChange(of: searchText) { _ in
                            if !searchingPicto {
                                // Se hace el filtrado por nombre dos veces. Esto quizás se podría evitar.
                                let catsInScreenIds: [String] = catVM.getCats(nameFilter: searchText).map {$0.id!}
                                if !catsInScreenIds.contains(pickedCategoryId) {
                                    pickedCategoryId = catsInScreenIds.first ?? ""
                                }
                            }
                        }
                    
                    if patient != nil {
                        Text(patient!.buildPatientTitle())
                            .font(.system(size: 30))
                            .padding(.horizontal, 25)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isDeleting.toggle()
                    }){
                        HStack{
                            Text(isDeleting ? "Cancelar" : "Eliminar Pictograma")
                                .font(.headline)
                        }
                    }
                    .padding(10)
                    .background(isDeleting || pictosInScreen.count == 0 ? .gray : .red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .allowsHitTesting(pictosInScreen.count > 0)
                }
                .frame(height: 40)
                .background(Color.white)
                .padding(.vertical)
                .padding(.horizontal, 70)
                
                // Barra de búsqueda, selector de categoría y botones para editar y agregar categorías
                HStack(spacing: 15) {
                    
                    Text("Categorias")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.gray)
                    
                    HStack{
                        let editCatButtonisDisabled: Bool = pickedCategoryId.isEmpty || catVM.getCat(catId: pickedCategoryId) == nil
                        //Editar categoria
                        ButtonWithImageView(text: "Editar", width: 120, systemNameImage: "pencil", imagePosition: .left, imagePadding: 2, isDisabled: editCatButtonisDisabled){
                            catBeingEdited = catVM.getCat(catId: pickedCategoryId)
                            isEditingCat = true
                        }
                        
                        //Agregar categoria
                        ButtonWithImageView(text: "Agregar", width: 120, systemNameImage: "plus", imagePosition: .left, imagePadding: 2){
                            catBeingEdited = nil
                            isEditingCat = true
                        }
                    }
                    .padding([.leading, .top, .bottom])
                    .padding(.trailing, 20)
                    
                    Divider()
                    
                    CategoryPickerView(categoryModels: catsInScreen, pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                }
                .frame(height: 60)
                .background(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
               
                Rectangle()
                    .frame(height: 20.0, alignment: .bottom)
                    .foregroundColor(currCat?.buildColor() ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                
                // Cuadrícula de pictogramas
                if catsInScreen.count == 0 {
                    Text("No hay pictogramas")
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                } else if pictosInScreen.count == 0 && !searchText.isEmpty {
                    Text("Sin resultados")
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.white)
                } else {
                    PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 165, pictoHeight: 165) {
                        pictoBeingEdited = nil
                        isEditingPicto = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .sheet(isPresented: $isEditingPicto) { [pictoBeingEdited] in
                PictogramEditorWindowView(pictoModel: pictoBeingEdited, isEditingPicto: $isEditingPicto, pictoVM: pictoVM, catVM: catVM, pickedCategoryId: $pickedCategoryId, searchText: $searchText)
            }
            .sheet(isPresented: $isEditingCat) { [catBeingEdited] in
                CategoryEditorWindowView(catModel: catBeingEdited, isEditingCat: $isEditingCat, pictoVM: pictoVM, catVM: catVM, pickedCategoryId: $pickedCategoryId, searchText: $searchText)
            }
            .customAlert(title: "Error", message: "La operación no pudo ser realizada", isPresented: $showErrorMessage) // Alerta de error
            .customConfirmAlert(title: "Confirmar Eliminación", message: "El pictograma será eliminado para siempre.", isPresented: $showDeleteAlert) {
                if pictoModelToDelete != nil {
                    Task {
                        if !pictoModelToDelete!.imageUrl.isEmpty {
                            _  = await imageHandler.deleteImage(donwloadUrl: pictoModelToDelete!.imageUrl)
                        }
                        pictoVM.removePicto(pictoId: pictoModelToDelete!.id!) { error in
                            if error != nil {
                                showErrorMessage = true
                            } else {
                                isDeleting = false
                            }
                        }
                    }
                } else {
                    // El pictograma a eliminar está vacío. 
                }
            }
        }
        // Si la categoría seleccionada es nula y no ha sido elegida por el usuario, seleccionamos la primera categoría
        .onChange(of: catVM.categories) { _ in
             if !userHasChosenCat {
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
                        pictoModelToDelete = pictoModel
                        showDeleteAlert = true
                    } else {
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
