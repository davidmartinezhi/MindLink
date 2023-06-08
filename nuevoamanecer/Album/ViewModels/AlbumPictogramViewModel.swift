//
//  AlbumPictogramViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class AlbumPictogramViewModel {
    private var listenerHandle: ListenerRegistration? = nil
    private var pictoCollection: CollectionReference
    
    init(collectionPath: String){
        self.pictoCollection = Firestore.firestore().collection(collectionPath)
    }
    
    func getPicto(pictoId: String) async -> PictogramModel? {
        return try? await self.pictoCollection.document(pictoId).getDocument(as: PictogramModel.self)
    }
    
    func getPictos(pictoIds: [String]) async -> [String:PictogramModel]? {
        var pictoModels: [String:PictogramModel] = [:] // [id:PictogramModel]
        
        for pictoId in pictoIds {
            let pictoModel: PictogramModel? = await self.getPicto(pictoId: pictoId)
            
            if pictoModel == nil {
                return nil
            } else {
                pictoModels[pictoModel!.id!] = pictoModel!
            }
        }
        
        return pictoModels
    }
}
