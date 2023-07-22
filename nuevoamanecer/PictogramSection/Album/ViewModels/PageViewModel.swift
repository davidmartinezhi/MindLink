//
//  PageViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

enum SortType: String, CaseIterable, Identifiable {
    case byName = "Nombre"
    case byCreatedAt = "Creación"
    case byLastOpenedAt = "Uso"
    
    var id: Self {self}
}

class PageViewModel: ObservableObject {
    @Published private var pages: [String:PageModel] = [:]// [pageId:PageModel]
    private var listenerHandle: ListenerRegistration? = nil
    private var pageCollection: CollectionReference
    
    init(collectionPath: String){
        self.pageCollection = Firestore.firestore().collection(collectionPath)
        
        listenerHandle = pageCollection.addSnapshotListener { snap, error in
            if let error = error {
                // Failure.
                print(error.localizedDescription)
                return
            }
            
            if let docChanges: [DocumentChange] = snap?.documentChanges {
                for docChange in docChanges {
                    if let pageModel: PageModel = try? docChange.document.data(as: PageModel.self){
                        self.updatePage(pageModel: pageModel, changeType: docChange.type)
                    } else {
                        // Failure: unsuccessful mapping.
                    }
                }
            } else {
                // Failure: snap (QuerySnapshot) has no value (nil).
            }
        }
    }
    
    private func updatePage(pageModel: PageModel, changeType: DocumentChangeType) -> Void {
        switch changeType {
        case .added, .modified:
            self.pages[pageModel.id!] = pageModel
            self.objectWillChange.send()
        case .removed:
            self.pages.removeValue(forKey: pageModel.id!)
        }
    }
    
    func getPage(pageId: String) -> PageModel? {
        return self.pages[pageId]
    }
    
    func getPages(sortType: SortType, ascending: Bool) -> [PageModel] {
        switch sortType {
        case .byName:
            return Array(self.pages.values).sorted(by: ascending ? {$0.name < $1.name} : {$0.name > $1.name})
        case .byCreatedAt:
            return Array(self.pages.values).sorted(by: ascending ? {$0.createdAt < $1.createdAt} : {$0.createdAt > $1.createdAt})
        case .byLastOpenedAt:
            return Array(self.pages.values).sorted(by: ascending ? {$0.lastOpenedAt < $1.lastOpenedAt} : {$0.lastOpenedAt > $1.lastOpenedAt})
        }
    }
    
    func getPages(sortType: SortType, ascending: Bool, textFilter: String) -> [PageModel] {
        let textFilterLowerd: String = textFilter.lowercased().replacingOccurrences(of: " " , with: "")
        
        return self.getPages(sortType: sortType, ascending: ascending).filter {
            $0.name.lowercased().replacingOccurrences(of: " " , with: "").contains(textFilterLowerd)
        }
    }
    
    func addPage(pageModel: PageModel, completition: @escaping (Error?)->Void) -> Void {
        do {
            _ = try self.pageCollection.addDocument(from: pageModel) { error in
                completition(error)
            }
        } catch let error {
            completition(error)
        }
    }
    
    func removePage(pageId: String, completition: @escaping (Error?)->Void) -> Void {
        self.pageCollection.document(pageId).delete(){ error in
            completition(error)
        }
    }
    
    func editPage(pageId: String, pageModel: PageModel, completition: @escaping (Error?)->Void) -> Void {
        do {
            try self.pageCollection.document(pageId).setData(from: pageModel){ error in
                completition(error)
            }
        } catch let error {
            completition(error)
        }
    }
    
    func updatePageLastOpenedAt(pageId: String, completition: @escaping (Error?)->Void) -> Void {
        pageCollection.document(pageId).updateData(["lastOpenedAt": FieldValue.serverTimestamp()]){ error in
            completition(error)
        }
    }
}
