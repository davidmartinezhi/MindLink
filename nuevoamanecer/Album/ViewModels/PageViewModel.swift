//
//  PageViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PageViewModel: ObservableObject {
    @Published private var pages: [String:PageModel] = [:] // [pageId:PageModel]
    private var listenerHandle: ListenerRegistration? = nil
    private var pageCollection: CollectionReference
    var count: Int {
        return pages.count
    }
    
    init(collectionPath: String){
        self.pageCollection = Firestore.firestore().collection(collectionPath)
        
        listenerHandle = self.pageCollection.addSnapshotListener { snap, error in
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
        case .removed:
            self.pages.removeValue(forKey: pageModel.id!)
        }
    }
    
    func getPages() -> [PageModel]{
        return Array(self.pages.values).sorted{$0.pageNumber < $1.pageNumber}
    }
    
    func addPage(name: String, completition: @escaping (Error?)->Void) -> Void {
        let pageModel: PageModel = PageModel(name: name, pageNumber: self.count+1, pictogramsInPage: [])
        
        do {
            _ = try self.pageCollection.addDocument(from: pageModel){ error in
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
}
