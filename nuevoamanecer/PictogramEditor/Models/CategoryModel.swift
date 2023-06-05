//
//  CategoryModel.swift
//  Comunicador
//
//  Created by emilio on 25/05/23.
//

import SwiftUI
import Foundation
import FirebaseFirestoreSwift

struct CategoryModel: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var color: CategoryColor
    
    func isValidCateogry() -> Bool {
        if name.isEmpty || name.count > 20 { // Definir número máximo de caracteres.
            return false 
        } else if !color.isValidCategoryColor() {
            return false
        }
        return true
    }
    
    func isEqualTo(_ catModel: CategoryModel) -> Bool {
        return name == catModel.name && color.isEqualTo(catModel.color)
    }
    
    func buildColor() -> Color {
        return Color(red: color.r, green: color.g, blue: color.b)
    }
    
    func buildColor(colorShift: Double) -> Color {
        return Color(red: color.r + colorShift, green: color.g + colorShift, blue: color.b + colorShift)
    }
    
    static func defaultCategory() -> CategoryModel {
        return CategoryModel(name: "Nombre", color: CategoryColor(r: 1, g: 1, b: 1))
    }
}

struct CategoryColor: Codable {
    var r: Double
    var g: Double
    var b: Double
    
    func isValidCategoryColor() -> Bool {
        if r < 0 || r > 1 {
            return false
        } else if g < 0 || g > 1 {
            return false
        } else if b < 0 || b > 1 {
            return false
        }
        return true 
    }
    
    func isEqualTo(_ catColorModel: CategoryColor) -> Bool {
        return r == catColorModel.r && g == catColorModel.g && b == catColorModel.b
    }
}
