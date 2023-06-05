//
//  PageViewModel.swift
//  Comunicador
//
//  Created by emilio on 26/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class PageViewModel: ObservableObject {
    @Published private var pages: [String:PageModel] = [:]
    private var pageCollection: CollectionReference = Firestore.firestore().collection("pages")
    private var listenerHandle: ListenerRegistration? = nil
    
    init(){
        listenerHandle = self.pageCollection.addSnapshotListener { snap, error in
            if let error = error {
                // Error
                print(error.localizedDescription)
                return
            }
            
            if let docChanges: [DocumentChange] = snap?.documentChanges {
                for docChange in docChanges {
                    if let pageModel: PageModel = try? docChange.document.data(as: PageModel.self){
                        self.updatePage(pageModel: pageModel, changeType: docChange.type)
                    } else {
                        // Manejar caso en el que el pictograma modificado no puede ser procesado.
                    }
                }
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
    
    func getPages() -> [PageModel] {
        return Array(self.pages.values)
    }
    
    func getNumPages() -> Int {
        return self.pages.count
    }
    
    func getPageName(pageId: String) -> String? {
        if let pageModel: PageModel = self.pages[pageId] {
            return pageModel.name
        }
        return nil
    }
    
    func getPageNumber(pageId: String) -> Int? {
        if let pageModel: PageModel = self.pages[pageId] {
            return pageModel.pageNumber
        }
        return nil
    }
    
    func addEmptyPage(name: String, pageNumber: Int) -> Void {
        let emptyPageModel: PageModel = PageModel(name: name, pageNumber: pageNumber, pictogramsInPage: [])
                
        do {
            _ = try self.pageCollection.addDocument(from: emptyPageModel) {error in
                if let error = error {
                    // Error: no fue posible añadir una nueva hoja a la colección.
                    print(error.localizedDescription)
                } else {
                    // Adición exitosa.
                }
            }
            
        } catch {
            // Manejar error.
        }
    }
    
    
    func removePage(pageId: String) -> Void {
        if self.pages[pageId] == nil { // Podría no ser necesario.
            return
        }
        
        self.pageCollection.document(pageId).delete() { error in
            if let error = error {
                // Error: la eliminación no fue posible, manejar error.
                print(error.localizedDescription)
            } else {
                // Eliminación exitosa.
            }
        }
    }
    
    func editPageName(pageId: String, name: String) -> Void {
        if self.pages[pageId] == nil { // No existe una página con el id dado.
            return
        }
        
        self.pageCollection.document(pageId).updateData(["name": name]){ error in
            if let error = error {
                // Error: la edición del nombre no fue posible.
                print(error.localizedDescription)
            } else {
                // Edición exitosa.
            }
        }
    }
    
    func editPageNumber(pageId: String, pageNumber: Int) -> Void {
        if self.pages[pageId] == nil {
            return
        }
        
        self.pageCollection.document(pageId).updateData(["pageNumber": pageNumber]){ error in
            if let error = error {
                // Error: la edición de la página no fue posible.
                print(error.localizedDescription)
            } else {
                // Edición exitosa.
            }
        }
    }
    
    func swapPageNumber(pageIdA: String, pageIdB: String) -> Void {
        if self.pages[pageIdA] == nil || self.pages[pageIdB] == nil {
            return
        }
                
        self.editPageNumber(pageId: pageIdA, pageNumber: self.pages[pageIdB]!.pageNumber)
        self.editPageNumber(pageId: pageIdB, pageNumber: self.pages[pageIdA]!.pageNumber)
    }
    
    func addPictoToPage(pageId: String, pictoId: String, xPos: Double, yPos: Double, size: Double) -> Void {
        if self.pages[pageId] == nil { // No existe una página con el id dado.
            return
        }
        
        let pictoInPage: PictogramInPage = PictogramInPage(pictoId: pictoId, isBasePictogram: false , size: size, xPos: xPos, yPos: yPos)
        
        do {
            _ = try self.pageCollection.document(pageId).collection("pictogramsInPage").addDocument(from: pictoInPage) { error in
                if let error = error {
                    // Error: imposible añadir la página al album.
                    print(error.localizedDescription)
                } else {
                    // Adición exitosa.
                }
            }
        } catch {
            // Manejar error
        }
    }
    
    func removePictoFromPage(pageId: String, pictoInPageId: String) -> Void {
        if self.pages[pageId] == nil {
            return
        }
        
        self.pageCollection.document(pageId).collection("pictogramsInPage").document(pictoInPageId).delete() { error in
            if let error = error {
                // Error: eliminación no fue exitosa.
                print(error.localizedDescription)
            } else {
                // Eliminación exitosa.
            }
        }
    }
    
    func editPictoInPage(pageId: String) -> Void {
        
    }
        
    func stopListening() -> Void {
        self.listenerHandle?.remove()
    }
}
