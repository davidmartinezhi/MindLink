//
//  PictogramModel.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PictogramModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var imageUrl: String
    var categoryId: String
    
    func isValidPictogram() -> Bool {
        if name.isEmpty || name.count > 20 { // Definir número máximo de caracteres.
            return false
        } else if categoryId.isEmpty {
            return false
        }
        return true
    }
    
    func isEqualTo(_ pictoModel: PictogramModel) -> Bool {
        return name == pictoModel.name && categoryId == pictoModel.categoryId
    }
    
    static func defaultPictogram() -> PictogramModel {
        return PictogramModel(
            name: "Nombre",
            imageUrl: "",
            categoryId: ""
        )
    }
}
