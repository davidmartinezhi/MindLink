//
//  AlbumCache.swift
//  nuevoamanecer
//
//  Created by emilio on 27/07/23.
//

import Foundation

class BoardCache: ObservableObject {
    var pictoCache: PictogramCache
    var catCache: CategoryCache
    
    init(basePictoCollPath: String, patientPictoCollPath: String, baseCatCollPath: String, patientCatCollPath: String){
        self.pictoCache = PictogramCache(basePictoCollectionPath: basePictoCollPath, patientPictoCollectionPath: patientPictoCollPath)
        self.catCache = CategoryCache(baseCatCollectionPath: baseCatCollPath, patientCatCollectionPath: patientCatCollPath)
    }
    
    func getPicto(pictoId: String) -> PictogramModel? {
        return self.pictoCache.getPicto(pictoId: pictoId)
    }
    
    func getCat(catId: String) -> CategoryModel? {
        return self.catCache.getCat(catId: catId)
    }
    
    func populateBoard(pictosInPage: [PictogramInPage]) async -> Void {
        var addedPictos: [PictogramModel?] = []
        for pictoInPage in pictosInPage {
            let pictoModel: PictogramModel? = await self.pictoCache.addPictoToCache(pictoId: pictoInPage.pictoId, isBasePicto: pictoInPage.isBasePicto)
            addedPictos.append(pictoModel)
        }
        
        for i in 0..<addedPictos.count {
            if addedPictos[i] != nil {
                _ = await self.catCache.addCatToCache(catId: addedPictos[i]!.categoryId, isBaseCat: pictosInPage[i].isBasePicto)
            }
        }
        
        DispatchQueue.main.async { [self] in
            self.objectWillChange.send()
        }
    }
}
