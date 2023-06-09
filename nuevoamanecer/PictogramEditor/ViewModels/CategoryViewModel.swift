//
//  CategoryViewModel.swift
//  Comunicador
//
//  Created by emilio on 25/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore

enum CatError: Error, LocalizedError {
    case doesNotExist
    
    var errorDescription: String? {
        switch self {
        case .doesNotExist:
            return NSLocalizedString("Error: la categoría a editar no existe", comment: "")
        }
    }
}

// CategoryViewModel: interface that provides an access to a Firestore collection of categories, found in
// in the path given in the parameter 'collectionPath' of the class' initializer.
class CategoryViewModel: ObservableObject {
    @Published private var categories: [String:CategoryModel] = [:] // [categoryId:CategoryModel]
    private var listenerHandle: ListenerRegistration? = nil
    private var catCollection: CollectionReference
    
    init(collectionPath: String){
        catCollection = Firestore.firestore().collection(collectionPath)
        
        listenerHandle = catCollection.addSnapshotListener { snap, error in
            if let error = error {
                // Failure. 
                print(error.localizedDescription)
                return
            }
            
            if let docChanges: [DocumentChange] = snap?.documentChanges {
                for docChange in docChanges {
                    if let catModel: CategoryModel = try? docChange.document.data(as: CategoryModel.self){
                        self.updateCat(catModel: catModel, changeType: docChange.type)
                    } else {
                        // Failure: unsuccessful mapping.
                    }
                }
            } else {
                // Failure: snap (QuerySnapshot) has no value (nil).
            }
        }
    }
    
    // updateCat: auxiliary function, handles a document change in the observed collection.
    private func updateCat(catModel: CategoryModel, changeType: DocumentChangeType) -> Void {
        switch changeType {
        case .added, .modified:
            self.categories[catModel.id!] = catModel
        case .removed:
            self.categories.removeValue(forKey: catModel.id!)
        }
    }
    
    func getCat(catId: String) -> CategoryModel? {
        return self.categories[catId]
    }
    
    // getFirstCat: returns the first category of the stored collection of categories.
    func getFirstCat() -> CategoryModel? {
        return self.getCats().first
    }
        
    func getCats() -> [CategoryModel] {
        return Array(self.categories.values).sorted{ elemA, elemB in
            return elemA.name < elemB.name
        }
    }
                        
    func addCat(name: String, color: (r: Double, g: Double, b: Double), completition: @escaping (Error?, String?)->Void) -> Void {
        let catModel: CategoryModel = CategoryModel(name: name, color: CategoryColor(r: color.r, g: color.g, b: color.b))
        var docRef: DocumentReference?
        
        do {
            docRef = try self.catCollection.addDocument(from: catModel) {error in
                if let error = error {
                    // Failure: unable to add cateogry to the collection.
                    completition(error, nil)
                } else {
                    // Adición exitosa.
                    completition(nil, docRef?.documentID)
                }
            }
        } catch let error {
            // Failure: unable to add document to the collection.
            completition(error, nil)
        }
    }
    
    func addCat(catModel: CategoryModel, completition: @escaping (Error?, String?)->Void) -> Void {
        var docRef: DocumentReference?

        do {
            docRef = try self.catCollection.addDocument(from: catModel) {error in
                if let error = error {
                    // Failure: unable to add document to the collection.
                    completition(error, nil)
                } else {
                    // Success.
                    completition(nil, docRef?.documentID)
                }
            }
        } catch let error {
            // Failure: unable to add document to the collection.
            completition(error, nil)
        }
    }
    
    func removeCat(catId: String, completition: @escaping (Error?)->Void) -> Void {
        if self.categories[catId] == nil {
            completition(CatError.doesNotExist)
            return
        }
        
        self.catCollection.document(catId).delete(){ error in
            if let error = error {
                // Failure: unable to remove document from the collection.
                completition(error)
            } else {
                // Success.
                completition(nil)
            }
        }
    }
    
    func editCat(catId: String, name: String, color: (r: Double, g: Double, b: Double), completition: @escaping (Error?)->Void) -> Void {
        if self.categories[catId] == nil {
            completition(CatError.doesNotExist)
            return
        }
        
        let catModel: CategoryModel = CategoryModel(name: name, color: CategoryColor(r: color.r, g: color.g, b: color.b))
        
        do {
            try self.catCollection.document(catId).setData(from: catModel) { error in
                if let error = error {
                    // Failure: unable to edit document from the collection.
                    completition(error)
                } else {
                    // Succcess.
                    completition(nil)
                }
            }
        } catch let error {
            // Failure: unable to edit document from the collection.
            completition(error)
        }
    }
    
    func editCat(catId: String, catModel: CategoryModel, completition: @escaping (Error?)->Void) -> Void {
        if self.categories[catId] == nil {
            completition(CatError.doesNotExist)
            return
        }
        
        do {
            try self.catCollection.document(catId).setData(from: catModel) { error in
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
    
    func editCatName(catId: String, name: String, completition: @escaping (Error?)->Void) -> Void {
        if self.categories[catId] == nil {
            completition(CatError.doesNotExist)
            return
        }
        
        self.catCollection.document(catId).updateData(["name": name]){ error in
            if let error = error {
                // Failure: unable to edit document from the collection.
                completition(error)
            } else {
                // Success.
                completition(nil)
            }
        }
    }
        
    func editCatColor(catId: String, color: (r: Double, g: Double, b: Double), completition: @escaping (Error?)->Void) -> Void {
        if self.categories[catId] == nil {
            completition(CatError.doesNotExist)
            return
        }
        
        let colorDict: [String:Double] = ["r": color.r, "g": color.g, "b": color.b]
        self.catCollection.document(catId).updateData(["color": colorDict]){ error in
            if let error = error {
                // Failure: unable to edit document from the collection.
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
