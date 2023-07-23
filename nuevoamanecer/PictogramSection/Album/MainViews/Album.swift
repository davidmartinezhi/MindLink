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
        
    @State var showingOptionsOf: String? = nil // Id de la página del álbum
    @State var pageToDelete: String? = nil // Id de la página del álbum
    @State var isDeleting: Bool = false
    
    init(patientId: String){
        self.patientId = patientId
        _pageVM = StateObject(wrappedValue: PageViewModel(collectionPath: "Patient/\(patientId)/pages"))
        _pictoCache = StateObject(wrappedValue: PictogramCache(basePictoCollectionPath: "basePictograms", patientPictoCollectionPath: "Patient/\(patientId)/pictograms"))
        _catCache = StateObject(wrappedValue: CategoryCache(baseCatCollectionPath: "baseCategories", patientCatCollectionPath: "Patient/\(patientId)/categories"))
    }
    
    var body: some View {
        GeometryReader {geo in
            NavigationStack {
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
                            NavigationLink {
                                PageEdit(patientId: patientId, pageVM: pageVM, pageModel: PageModel.defaultPage(), pictoCache: pictoCache, catCache: catCache, isNew: true)
                            } label: {
                                VStack {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: thumbnailWidth * 0.5)
                                        .foregroundColor(.blue)
                                    
                                    Text("Nueva Página")
                                        .bold()
                                        .foregroundColor(.blue)
                                }
                            }
                            .frame(width: thumbnailWidth, height: thumbnailHeight)
                            
                            ForEach(pagesInScreen, id: \.id){ pageModel in
                                NavigationLink {
                                    PageDisplay(patientId: patientId, pageVM: pageVM, pageModel: pageModel, pictoCache: pictoCache, catCache: catCache)
                                } label: {
                                    PageThumbnail(pageModel: pageModel, pictoCache: pictoCache, catCache: catCache)
                                        .id(UUID()) // ???
                                        .overlay(alignment: .top){
                                            let performWhenDeleted: () -> Void = {
                                                pageToDelete = pageModel.id!
                                                isDeleting = true
                                            }
                                            
                                            PageOptionsView(pageId: pageModel.id!, showingOptionsOf: $showingOptionsOf, patientId: patientId, pageVM: pageVM, pageModel: pageModel, pictoCache: pictoCache, catCache: catCache, performWhenDeleted: performWhenDeleted)
                                                .frame(width: thumbnailWidth * 0.75, height: thumbnailHeight * 0.9)
                                        }
                                }
                                .frame(width: thumbnailWidth, height: thumbnailHeight)
                            }
                        }
                    }
                    .padding(.vertical, 30)
                    .frame(width: gridWidth)
                }
            }
        }
        .onAppear {
            showingOptionsOf = nil
        }
        .customConfirmAlert(title: "Eliminar página", message: "Presione confirmar para eliminar permanentemente la página.", isPresented: $isDeleting){
            if pageToDelete != nil {
                pageVM.removePage(pageId: pageToDelete!){ error in
                    if error != nil {
                        // Error en la eliminación
                    } else {
                        // Eliminación exitosa
                        isDeleting = false 
                    }
                }
            }
        }
    }
}
