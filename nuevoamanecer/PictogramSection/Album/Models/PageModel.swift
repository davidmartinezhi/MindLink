//
//  PageModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PageModel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var createdAt: Date
    var lastOpenedAt: Date
    var pictogramsInPage: [PictogramInPage]
    
    static func ==(lhs: PageModel, rhs: PageModel) -> Bool {
        if lhs.pictogramsInPage.count != rhs.pictogramsInPage.count {
            return false 
        }
        
        var result: Bool = true
        result = result && lhs.id == rhs.id
        result = result && lhs.name == rhs.name
        result = result && lhs.createdAt == rhs.createdAt
        result = result && lhs.lastOpenedAt == rhs.lastOpenedAt
        result = result && lhs.pictogramsInPage == rhs.pictogramsInPage
        return result
    }
    
    static func defaultPage(name: String = "Hoja sin nombre") -> PageModel {
        return PageModel(name: name,
                         createdAt: Date.now,
                         lastOpenedAt: Date.now,
                         pictogramsInPage: [])
    }
}

struct PictogramInPage: Codable, Equatable {
    var pictoId: String
    var isBasePicto: Bool
    var xOffset: Double = 0 // -1 ... 1
    var yOffset: Double = 0 // -1 ... 1
    var scale: Double = 1 // 0.5 ... 3
    
    static func ==(lhs: PictogramInPage, rhs: PictogramInPage) -> Bool {
        var result: Bool = true
        result = result && lhs.pictoId == rhs.pictoId
        result = result && lhs.isBasePicto == rhs.isBasePicto
        result = result && lhs.xOffset == rhs.xOffset
        result = result && lhs.yOffset == rhs.yOffset
        result = result && lhs.scale == rhs.scale
        return result
    }
}
