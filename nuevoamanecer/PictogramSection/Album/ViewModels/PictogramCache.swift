//
//  AlbumPictogramViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
 
 class PictogramCache {
 private var cachedPictos: [String:PictogramModel] = [:]
 private var basePictoCollection: CollectionReference
 private var patientPictoCollection: CollectionReference
 
 init(basePictoCollectionPath: String, patientPictoCollectionPath: String){
 self.basePictoCollection = Firestore.firestore().collection(basePictoCollectionPath)
 self.patientPictoCollection = Firestore.firestore().collection(patientPictoCollectionPath)
 }
 
 func getPicto(pictoId: String) -> PictogramModel? {
 return cachedPictos[pictoId]
 }
 
 func addPictoToCache(pictoId: String, isBasePicto: Bool) async -> PictogramModel? {
 if cachedPictos[pictoId] == nil {
 if isBasePicto {
 if let pictoModel: PictogramModel = try? await basePictoCollection.document(pictoId).getDocument(as: PictogramModel.self) {
 self.cachedPictos[pictoId] = pictoModel
 }
 } else {
 if let pictoModel: PictogramModel = try? await patientPictoCollection.document(pictoId).getDocument(as: PictogramModel.self) {
 self.cachedPictos[pictoId] = pictoModel
 }
 }
 }
 
 return cachedPictos[pictoId]
 }
 
 func removePictoFromCache(pictoId: String) -> Void {
 if cachedPictos[pictoId] != nil {
 cachedPictos.removeValue(forKey: pictoId)
 }
 }
 }
 
 */
