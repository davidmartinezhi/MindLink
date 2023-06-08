//
//  AlbumCategoryViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AlbumCategoryViewModel {
    private var listenerHandle: ListenerRegistration? = nil
    private var catCollection: CollectionReference
    
    init(collectionPath: String){
        self.catCollection = Firestore.firestore().collection(collectionPath)
    }
    
    func getCat(catId: String) async -> CategoryModel? {
        return try? await self.catCollection.document(catId).getDocument(as: CategoryModel.self)
    }
    
    func getCats(catIds: [String]) async -> [String:CategoryModel]? {
        var catModels: [String:CategoryModel] = [:] // [id:CategoryModel]
        
        for catId in catIds {
            let catModel: CategoryModel? = await self.getCat(catId: catId)
            
            if catModel == nil {
                return nil
            } else {
                catModels[catModel!.id!] = catModel!
            }
        }
        
        return catModels
    }
}

