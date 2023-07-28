//
//  AlbumCategoryViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CategoryCache {
    private var cachedCats: [String:CategoryModel] = [:]
    private var baseCatCollection: CollectionReference
    private var patientCatCollection: CollectionReference
    
    init(baseCatCollectionPath: String, patientCatCollectionPath: String){
        baseCatCollection = Firestore.firestore().collection(baseCatCollectionPath)
        patientCatCollection = Firestore.firestore().collection(patientCatCollectionPath)
    }
    
    func getCat(catId: String) -> CategoryModel? {
        return cachedCats[catId]
    }
    
    func addCatToCache(catId: String, isBaseCat: Bool) async -> CategoryModel? {
        if cachedCats[catId] == nil {
            if isBaseCat {
                if let catModel: CategoryModel = try? await baseCatCollection.document(catId).getDocument(as: CategoryModel.self) {
                    self.cachedCats[catId] = catModel
                }
            } else {
                if let catModel: CategoryModel = try? await patientCatCollection.document(catId).getDocument(as: CategoryModel.self) {
                    self.cachedCats[catId] = catModel
                }
            }
        }
        
        return cachedCats[catId]
    }
    
    func removeCatFromCache(catId: String) -> Void {
        if cachedCats[catId] != nil {
            cachedCats.removeValue(forKey: catId)
        }
    }
}
