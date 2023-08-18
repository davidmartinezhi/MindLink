//
//  PictogramModel.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PictogramModel: Identifiable, Codable, Comparable {
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
    
    // isEqualTo: determina si dos instancias de PictogramModel son iguales, sin considerar sus ids.
    func isEqualTo(_ pictoModel: PictogramModel) -> Bool {
        return name == pictoModel.name && categoryId == pictoModel.categoryId
    }
    
    static func ==(lhs: PictogramModel, rhs: PictogramModel) -> Bool {
        var result: Bool = true
        result = result && lhs.id == rhs.id
        result = result && lhs.name == rhs.name
        result = result && lhs.imageUrl == rhs.imageUrl
        result = result && lhs.categoryId == rhs.categoryId
        return result
    }
    
    static func <(lhs: PictogramModel, rhs: PictogramModel) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    static func >(lhs: PictogramModel, rhs: PictogramModel) -> Bool {
        return lhs.name.lowercased() > rhs.name.lowercased()
    }
    
    static func <=(lhs: PictogramModel, rhs: PictogramModel) -> Bool {
        return lhs.name.lowercased() <= rhs.name.lowercased()
    }
    
    static func >=(lhs: PictogramModel, rhs: PictogramModel) -> Bool {
        return lhs.name.lowercased() >= rhs.name.lowercased()
    }
    
    static func defaultPictogram(catId: String? = nil) -> PictogramModel {
        return PictogramModel(
            name: "",
            imageUrl: "",
            categoryId: catId ?? ""
        )
    }
}
