//
//  AlbumCache.swift
//  nuevoamanecer
//
//  Created by emilio on 27/07/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BoardCache: ObservableObject {
    @Published private var cachedPictos: [String:PictogramModel] = [:]
    @Published private var cachedCats: [String:CategoryModel] = [:]
    private var basePictoCollection: CollectionReference
    private var patientPictoCollection: CollectionReference
    private var baseCatCollection: CollectionReference
    private var patientCatCollection: CollectionReference
    
    init(basePictoCollPath: String, patientPictoCollPath: String, baseCatCollPath: String, patientCatCollPath: String){
        self.basePictoCollection = Firestore.firestore().collection(basePictoCollPath)
        self.patientPictoCollection = Firestore.firestore().collection(patientPictoCollPath)
        
        self.baseCatCollection = Firestore.firestore().collection(baseCatCollPath)
        self.patientCatCollection = Firestore.firestore().collection(patientCatCollPath)
    }
    
    func getPicto(pictoId: String) -> PictogramModel? {
        return self.cachedPictos[pictoId]
    }
    
    func getCat(catId: String) -> CategoryModel? {
        return self.cachedCats[catId]
    }
    
    func addPictoToCache(pictoId: String, isBasePicto: Bool) async -> PictogramModel? {
        if self.cachedPictos[pictoId] == nil {
            if isBasePicto {
                if let pictoModel: PictogramModel = try? await basePictoCollection.document(pictoId).getDocument(as: PictogramModel.self){
                    DispatchQueue.main.async { [self] in
                        self.cachedPictos[pictoId] = pictoModel
                    }
                }
            } else {
                if let pictoModel: PictogramModel = try? await patientPictoCollection.document(pictoId).getDocument(as: PictogramModel.self) {
                    DispatchQueue.main.async { [self] in
                        self.cachedPictos[pictoId] = pictoModel
                    }
                }
            }
        }
        
        return self.cachedPictos[pictoId]
    }
    
    func addCatToCache(catId: String, isBaseCat: Bool) async -> CategoryModel? {
        if self.cachedCats[catId] == nil {
            if isBaseCat {
                if let catModel: CategoryModel = try? await baseCatCollection.document(catId).getDocument(as: CategoryModel.self) {
                    DispatchQueue.main.async { [self] in
                        self.cachedCats[catId] = catModel
                    }
                }
            } else {
                if let catModel: CategoryModel = try? await patientCatCollection.document(catId).getDocument(as: CategoryModel.self) {
                    DispatchQueue.main.async { [self] in
                        self.cachedCats[catId] = catModel
                    }
                }
            }
        }
        
        return self.cachedCats[catId]
    }
    
    func populateBoard(pictosInPage: [PictogramInPage]) async -> Void {
        var addedPictos: [PictogramModel?] = []
        for pictoInPage in pictosInPage {
            let pictoModel: PictogramModel? = await self.addPictoToCache(pictoId: pictoInPage.pictoId, isBasePicto: pictoInPage.isBasePicto)
            addedPictos.append(pictoModel)
        }
        
        for i in 0..<addedPictos.count {
            if addedPictos[i] != nil {
                _ = await self.addCatToCache(catId: addedPictos[i]!.categoryId, isBaseCat: pictosInPage[i].isBasePicto)
            }
        }
    }
}
