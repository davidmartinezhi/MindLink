//
//  CategoryModel.swift
//  Comunicador
//
//  Created by emilio on 25/05/23.
//

import SwiftUI
import Foundation
import FirebaseFirestoreSwift

struct CategoryModel: Identifiable, Codable, Comparable {
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
    
    func buildColor() -> Color {
        return Color(red: color.r, green: color.g, blue: color.b)
    }
    
    func buildColor(colorShift: Double) -> Color {
        let rShift: Double = color.r + colorShift < 0 ? 0 : color.r + colorShift
        let gShift: Double = color.g + colorShift < 0 ? 0 : color.g + colorShift
        let bShift: Double = color.b + colorShift < 0 ? 0 : color.b + colorShift

        return Color(red: rShift, green: gShift, blue: bShift)
    }
    
    func buildColorCatColor(colorShift: Double) -> CategoryColor {
        let rShift: Double = color.r + colorShift < 0 ? 0 : color.r + colorShift
        let gShift: Double = color.g + colorShift < 0 ? 0 : color.g + colorShift
        let bShift: Double = color.b + colorShift < 0 ? 0 : color.b + colorShift

        
        return CategoryColor(r: rShift, g: gShift, b: bShift)
    }
    
    // isEqualTo: determina si dos instancias de CategoryModel son iguales, sin considerar sus ids. 
    func isEqualTo(_ catModel: CategoryModel) -> Bool {
        return name == catModel.name && color.isEqualTo(catModel.color)
    }
    
    static func ==(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        var result: Bool = true
        result = result && lhs.id == rhs.id
        result = result && lhs.name == rhs.name
        result = result && lhs.color.isEqualTo(rhs.color)
        return result
    }
    
    static func <(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    static func >(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name.lowercased() > rhs.name.lowercased()
    }
    
    static func <=(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name.lowercased() <= rhs.name.lowercased()
    }
    
    static func >=(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.name.lowercased() >= rhs.name.lowercased()
    }
    
    static func defaultCategory() -> CategoryModel {
        return CategoryModel(name: "", color: CategoryColor(r: 0.9, g: 0.9, b: 0.9))
    }
}

struct CategoryColor: Codable {
    var r: Double // 0...1
    var g: Double // 0...1
    var b: Double // 0...1
    
    init(r: Double, g: Double, b: Double){
        self.r = CategoryColor.normalizeColorValue(r)
        self.g = CategoryColor.normalizeColorValue(g)
        self.b = CategoryColor.normalizeColorValue(b)
    }
    
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
    
    func isSimilarTo(_ catColorModel: CategoryColor, range: Double) -> Bool {
        let _r = catColorModel.r
        let _g = catColorModel.g
        let _b = catColorModel.b
        
        if r > CategoryColor.normalizeColorValue(_r + range) || r < CategoryColor.normalizeColorValue(_r - range) {
            return false
        } else if g > CategoryColor.normalizeColorValue(_g + range) || g < CategoryColor.normalizeColorValue(_g - range) {
            return false
        } else if b > CategoryColor.normalizeColorValue(_b + range) || b < CategoryColor.normalizeColorValue(_b - range) {
            return false
        }
            
        return true
    }
    
    static func normalizeColorValue(_ colorValue: Double) -> Double {
        return colorValue > 1 ? 1 : (colorValue < 0 ? 0 : colorValue)
    }
}
