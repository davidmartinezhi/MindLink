//
//  PictogramViewModel.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore

enum PictoError: Error, LocalizedError {
    case doesNotExist
    
    var errorDescription: String? {
        switch self {
        case .doesNotExist:
            return NSLocalizedString("Error: el pictograma a editar no existe", comment: "")
        }
    }
}

enum PictogramProperty: String {
    case name = "name"
    case imageUrl = "imageUrl"
    case categoryId = "categoryId"
}

// PictogramViewModel: interface that provides an access to a Firestore collection of pictograms, found in
// in the path given in the parameter 'collectionPath' of the class' initializer.
class PictogramViewModel: ObservableObject {
    @Published private var pictograms: [String:PictogramModel] = [:] // [pictogramId:PictogramModel]
    private var categoryMap: [String:SortedArray<PictogramModel>] = [:] // [categoryId:SortedPictoArray]
    private var listenerHandle: ListenerRegistration? = nil
    private var pictoCollection: CollectionReference
    
    init(collectionPath: String){
        pictoCollection = Firestore.firestore().collection(collectionPath)
        
        listenerHandle = pictoCollection.addSnapshotListener { snap, error in
            if let error = error {
                // Failure. 
                print(error.localizedDescription)
                return
            }
            
            if let docChanges: [DocumentChange] = snap?.documentChanges {
                for docChange in docChanges {
                    if let pictoModel: PictogramModel = try? docChange.document.data(as: PictogramModel.self){
                        self.updatePicto(pictoModel: pictoModel, changeType: docChange.type)
                    } else {
                        // Failure: unsuccessful mapping.
                    }
                }
            } else {
                // Failure: snap (QuerySnapshot) has no value (nil).
            }
        }
    }
    
    // updatePicto: auxiliary function, handles a document change in the observed collection.
    private func updatePicto(pictoModel: PictogramModel, changeType: DocumentChangeType) -> Void {
        switch changeType {
        case .added:
            self.pictograms[pictoModel.id!] = pictoModel
            if self.categoryMap[pictoModel.categoryId] == nil {
                self.categoryMap[pictoModel.categoryId] = SortedArray<PictogramModel>()
            }
            self.categoryMap[pictoModel.categoryId]!.add(item: pictoModel)
            
        case .removed:
            if self.pictograms[pictoModel.id!] != nil {
                self.pictograms.removeValue(forKey: pictoModel.id!)
                self.categoryMap[pictoModel.categoryId]!.remove(item: pictoModel)
            }
        case .modified:
            let beforeChangePictoModel: PictogramModel = self.pictograms[pictoModel.id!]!
            self.pictograms[pictoModel.id!] = pictoModel

            if pictoModel.categoryId != beforeChangePictoModel.categoryId {
                self.categoryMap[beforeChangePictoModel.categoryId]!.remove(item: beforeChangePictoModel)
                
                if self.categoryMap[pictoModel.categoryId] == nil {
                    self.categoryMap[pictoModel.categoryId] = SortedArray<PictogramModel>()
                }
                self.categoryMap[pictoModel.categoryId]!.add(item: pictoModel)
            } else {
                self.categoryMap[pictoModel.categoryId]!.updateWith(item: beforeChangePictoModel, with: pictoModel)
            }
        }
    }
    
    // getPictosFromCat: returns an array of PictogramModels whose category has as id 'catId'.
    func getPictosFromCat(catId: String) -> [PictogramModel] {
        if self.categoryMap[catId] != nil {
            return self.categoryMap[catId]!.getItems()
        }
        return []
    }
    
    // getPictosFromCat: returns an array of PictogramModels whose category has as id 'catId'.
    // The corresponding models are then filtered by name, taking only those that contain 'nameFilter'.
    func getPictosFromCat(catId: String, nameFilter: String) -> [PictogramModel] {
        let cleanedNameFilter: String = nameFilter.cleanForSearch()
                
        if self.categoryMap[catId] != nil {
            let pictoModels: [PictogramModel] = self.categoryMap[catId]!.getItems()
            
            if cleanedNameFilter.isEmpty {
                return pictoModels
            } else {
                return pictoModels.filter {
                    $0.name.lowercased().contains(cleanedNameFilter)
                }
            }
        }
        return []
    }
    
    func getNumPictosInCat(catId: String) -> Int {
        if self.categoryMap[catId] != nil {
            return self.categoryMap[catId]!.count
        }
        return 0
    }
            
    func addPicto(name: String, imageUrl: String, cateogryId: String, completition: @escaping (Error?)->Void) -> Void {
        let pictoModel: PictogramModel = PictogramModel(name: name,
                                                        imageUrl: imageUrl,
                                                        categoryId: cateogryId)
        
        do {
            _ = try self.pictoCollection.addDocument(from: pictoModel){ error in
                if let error = error {
                    // Failure: unable to add document to the collection.
                    completition(error)
                } else {
                    // Success.
                    completition(nil)
                }
            }
        } catch let error {
            // Failure: unable to add document to the collection.
            completition(error)
        }
    }
    
    func addPicto(pictoModel: PictogramModel, completition: @escaping (Error?)->Void) -> Void {
        do {
            _ = try self.pictoCollection.addDocument(from: pictoModel){ error in
                if let error = error {
                    // Failure: unable to add document to the collection.
                    completition(error)
                } else {
                    completition(nil)
                }
            }
        } catch let error {
            // Failure: unable to add document to the collection.
            completition(error)
        }
    }
    
    func removePicto(pictoId: String, completition: @escaping (Error?)->Void) -> Void {
        self.pictoCollection.document(pictoId).delete() { error in
            if let error = error {
                // Failure: unable to remove document from the collection.
                completition(error)
            } else {
                // Success.
                completition(nil)
            }
        }
    }
    
    func editPicto(pictoId: String, name: String, imageUrl: String, cateogryId: String, completition: @escaping (Error?)->Void) -> Void {
        if self.pictograms[pictoId] == nil {
            completition(PictoError.doesNotExist)
            return // hola
        }
        
        let pictoModel: PictogramModel = PictogramModel(name: name,
                                                        imageUrl: imageUrl,
                                                        categoryId: cateogryId)
        
        do {
            try self.pictoCollection.document(pictoId).setData(from: pictoModel) { error in
                if let error = error {
                    // Failure: unable to edit document from the collection.
                    completition(error)
                } else {
                    // Success.
                    completition(nil)
                }
            }
        } catch let error {
            // Failure: unable to edit document from the collection.
            completition(error)
        }
    }
    
    func editPicto(pictoId: String, pictoModel: PictogramModel, completition: @escaping (Error?)->Void) -> Void {
        if self.pictograms[pictoId] == nil {
            completition(PictoError.doesNotExist)
            return
        }
                
        do {
            try self.pictoCollection.document(pictoId).setData(from: pictoModel) { error in
                if let error = error {
                    // Failure: unable to edit document from the collection.
                    completition(error)
                } else {
                    // Success.
                    completition(nil)
                }
            }
        } catch let error {
            // Failure: unable to edit document from the collection.
            completition(error)
        }
    }
    
    func editPictoProperty(pictoId: String, property: PictogramProperty, value: String, completition: @escaping (Error?)->Void) -> Void {
        if self.pictograms[pictoId] == nil {
            completition(PictoError.doesNotExist)
            return
        }
        
        self.pictoCollection.document(pictoId).updateData([property.rawValue: value]){ error in
            if let error = error {
                // Failure: unable to edit document property.
                completition(error)
            } else {
                // Success.
                completition(nil)
            }
        }
    }
        
    func stopListening() -> Void {
        self.listenerHandle?.remove()
    }
}
