//
//  PageWhiteboardView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageBoardView: View {
    @Binding var pageModel: PageModel
    @ObservedObject var pictoCache: PictogramCache
    @ObservedObject var catCache: CategoryCache
    
    var isEditing: Bool
    var soundOn: Bool
    
    var pictoBaseWidth: CGFloat
    var pictoBaseHeight: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<pageModel.pictogramsInPage.count, id: \.self){ i in
                    let pictoModel: PictogramModel? = pictoCache.getPicto(pictoId: pageModel.pictogramsInPage[i].pictoId)
                    let catModel: CategoryModel? = pictoModel != nil ? catCache.getCat(catId: pictoModel!.categoryId) : nil
                    
                    let performWhenDeleted: (PictogramInPage) -> Void = { pictoInPage in
                        if let pictoIndex: Int = self.pageModel.pictogramsInPage.firstIndex(of: pictoInPage){
                            self.pageModel.pictogramsInPage.remove(at: pictoIndex)
                        }
                    }
                    
                    if isEditing {
                        EditPictogramHolderView(pictoModel: pictoModel,
                                                catModel: catModel,
                                                pictoInPage: $pageModel.pictogramsInPage[i],
                                                performWhenDeleted: performWhenDeleted,
                                                pictoBaseWidth: pictoBaseWidth,
                                                pictoBaseHeight: pictoBaseWidth,
                                                spaceWidth: geo.size.width,
                                                spaceHeight: geo.size.height)
                    } else {
                        DisplayPictogramHolderView(pictoModel: pictoModel,
                                                   catModel: catModel,
                                                   pictoInPage: $pageModel.pictogramsInPage[i],
                                                   soundOn: soundOn,
                                                   pictoBaseWidth: pictoBaseWidth,
                                                   pictoBaseHeight: pictoBaseHeight,
                                                   spaceWidth: geo.size.width,
                                                   spaceHeight: geo.size.height)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .task {
            await populateBoard()
        }
        .onChange(of: pageModel) { _ in
            Task {
                await populateBoard()
            }
        }
    }
    
    private func populateBoard() async -> Void {
        var addedPictos: [PictogramModel?] = []
        for pictoInPage in pageModel.pictogramsInPage {
            let pictoModel: PictogramModel? = await pictoCache.addPictoToCache(pictoId: pictoInPage.pictoId, isBasePicto: pictoInPage.isBasePicto)
            addedPictos.append(pictoModel)
        }
        
        for i in 0..<addedPictos.count {
            if addedPictos[i] != nil {
                let isBaseCat: Bool = pageModel.pictogramsInPage[i].isBasePicto
                _ = await catCache.addCatToCache(catId: addedPictos[i]!.categoryId, isBaseCat: isBaseCat)
            }
        }
    }
}
