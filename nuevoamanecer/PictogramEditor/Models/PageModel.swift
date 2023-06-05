//
//  PageModel.swift
//  Comunicador
//
//  Created by emilio on 26/05/23.
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
    var pictoId: String
    var isBasePictogram: Bool 
    var size: Double
    var xPos: Double
    var yPos: Double
}
