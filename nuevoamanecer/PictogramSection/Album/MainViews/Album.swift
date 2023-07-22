//
//  Album.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import SwiftUI

struct Album: View {
    var patientId: String
    
    @StateObject var pageVM: PageViewModel
    @StateObject var pictoCache: PictogramCache
    @StateObject var catCache: CategoryCache
    
    @State var searchText: String = ""
    @State var sortType: SortType = .byLastOpenedAt
    @State var ascending: Bool = false
    @State var isEditing: Bool = false
    @State var isDeleting: Bool = false
    
    @State var isCreatingNewPage: Bool = false
        
    init(patientId: String){
        self.patientId = patientId
        _pageVM = StateObject(wrappedValue: PageViewModel(collectionPath: "Patient/\(patientId)/pages"))
        _pictoCache = StateObject(wrappedValue: PictogramCache(basePictoCollectionPath: "basePictograms", patientPictoCollectionPath: "Patient/\(patientId)/pictograms"))
        _catCache = StateObject(wrappedValue: CategoryCache(baseCatCollectionPath: "baseCategories", patientCatCollectionPath: "Patient/\(patientId)/categories"))
    }
    
    var body: some View {
        GeometryReader {geo in
            NavigationStack {
                ZStack {
                    VStack {
                        HStack(spacing: 15) {
                            SearchBarView(searchText: $searchText, placeholder: "Buscar Hoja", searchBarWidth: geo.size.width * 0.2, backgroundColor: .white)
                            
                            Text("Ordenar por:")
                            
                            Picker(selection: $sortType) {
                                ForEach(SortType.allCases){ sortTypeValue in
                                    Text(sortTypeValue.rawValue)
                                }
                            } label: {
                                Text(sortType.rawValue)
                            }
                            
                            Button {
                                ascending.toggle()
                            } label: {
                                Image(systemName: ascending ? "arrow.up" : "arrow.down")
                            }
                            
                            Spacer()
                            
                            ButtonWithImageView(text: isEditing ? "Cancelar" : "Editar Hoja", width: 150, systemNameImage: isEditing ? "xmark" : "pencil", background: isEditing ? .red : .blue) {
                                isEditing.toggle()
                            }
                            
                            ButtonWithImageView(text: "Agregar Hoja", width: 150, systemNameImage: "plus") {
                                isCreatingNewPage = true
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 70)
                        
                        Divider()
                        
                        let gridWidth: CGFloat = (geo.size.width  * 0.8)
                        let thumbnailWidth: CGFloat = 250
                        let thumbnailHeight: CGFloat = 200
                        let thumbnailHorSpacing: CGFloat = 35
                        let thumbnailVerSpacing: CGFloat = 50
                        let numThumbnailsPerRow: Int = Int((gridWidth + thumbnailHorSpacing) / (thumbnailWidth + thumbnailHorSpacing))
                        let gridColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: thumbnailHorSpacing, alignment: .center), count: numThumbnailsPerRow == 0 ? 1 : numThumbnailsPerRow)
                        
                        let pagesInScreen: [PageModel] = searchText.isEmpty ? pageVM.getPages(sortType: sortType, ascending: ascending) : pageVM.getPages(sortType: sortType, ascending: ascending, textFilter: searchText)
                        
                        ScrollView {
                            LazyVGrid(columns: gridColumns, spacing: thumbnailVerSpacing) {
                                ForEach(pagesInScreen, id: \.id){ pageModel in
                                    NavigationLink {
                                        if isEditing {
                                            PageEdit(patientId: patientId, pageVM: pageVM, pageModel: pageModel, pictoCache: pictoCache, catCache: catCache)
                                        } else {
                                            PageDisplay(patientId: patientId, pageVM: pageVM, pageModel: pageModel, pictoCache: pictoCache, catCache: catCache)
                                        }
                                    } label: {
                                        PageThumbnail(pageModel: pageModel, pictoCache: pictoCache, catCache: catCache)
                                            .id(UUID()) // ???
                                            .overlay(alignment: .topTrailing){
                                                if isEditing || isDeleting {
                                                    Image(systemName: isEditing ? "pencil.circle" : "xmark.circle")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .padding(30)
                                                        .frame(width: thumbnailWidth * 0.2)
                                                        .foregroundColor(isEditing ? .blue : .red)
                                                }
                                            }
                                    }
                                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                                }
                            }
                        }
                        .padding(.vertical, 30)
                        .frame(width: gridWidth)
                    }
                    
                    if isCreatingNewPage {
                        Button {
                            isCreatingNewPage = false 
                        } label: {
                            Color(.gray)
                                .opacity(0.1)
                                .ignoresSafeArea()
                        }
                        
                        PageCreationView(isCreatingNewPage: $isCreatingNewPage, pageVM: pageVM)
                    }
                }
            }
        }
        .onAppear {
            isEditing = false
        }
    }
}
