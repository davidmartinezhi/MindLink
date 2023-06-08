//
//  PageModel.swift
//  nuevoamanecer
//
//  Created by emilio on 07/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PageModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var pageNumber: Int
    var pictogramsInPage: [PictogramInPage]    
}

struct PictogramInPage: Codable {
    var isBasePicto: Bool
    var pictoId: String
    var scale: Double
    var xPos: Double
    var yPos: Double
}
