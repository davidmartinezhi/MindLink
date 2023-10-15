//
//  ColorMaker.swift
//  Comunicador
//
//  Created by emilio on 05/06/23.
//

import Foundation
import SwiftUI

struct ColorMaker {
    static func buildforegroundTextColor(r: Double, g: Double, b: Double) -> Color {
        return ColorMaker.colorLuminance(r: r, g: g, b: b) < 0.6 ? .white : .black
    }
    
    static func buildforegroundTextColor(catColor: CategoryColor) -> Color {
        return ColorMaker.colorLuminance(catColor: catColor) < 0.6 ? .white : .black
    }
    
    static func colorLuminance(r: Double, g: Double, b: Double) -> Double {
        return (r * 0.2126) + (g * 0.7152) + (b * 0.0722)
    }
    
    static func colorLuminance(catColor: CategoryColor) -> Double {
        return (catColor.r * 0.2126) + (catColor.g * 0.7152) + (catColor.b * 0.0722)
    }
    
    static func getBasicColors() -> [(r: Double, g: Double, b: Double)] {
        let colors: [(r: Double, g: Double, b: Double)] = [
            // Red shades
            (1, 0, 0),          // Red
            (0.75, 0, 0),       // Maroon
            (0.5, 0, 0),        // Dark Red
            
            // Orange shades
            (1, 0.5, 0),        // Orange
            (0.75, 0.25, 0),    // Burnt Orange
            (0.5, 0.25, 0),     // Dark Orange
            
            // Yellow shades
            (1, 1, 0),          // Yellow
            (0.75, 0.75, 0),    // Gold
            (0.5, 0.5, 0),      // Dark Yellow
            
            // Green shades
            (0, 1, 0),          // Green
            (0, 0.75, 0),       // Lime
            (0, 0.5, 0),        // Dark Green
            
            // Blue shades
            (0, 0, 1),          // Blue
            (0, 0, 0.75),       // Navy
            (0, 0, 0.5),        // Dark Blue
            
            // Purple shades
            (0.5, 0, 0.5),      // Purple
            (0.25, 0, 0.5),     // Indigo
            (0.25, 0, 0.25),    // Dark Purple
            
            // Pink shades
            (1, 0, 1),          // Pink
            (0.75, 0, 0.75),    // Magenta
            (0.5, 0, 0.5),      // Dark Pink
            
            // Brown shades
            (0.6, 0.4, 0.2),    // Brown
            (0.5, 0.25, 0),     // Dark Brown
            (0.4, 0.2, 0),      // Chocolate
            
            // Gray shades
            (0.75, 0.75, 0.75), // Silver
            (0.5, 0.5, 0.5),    // Gray
            (0.25, 0.25, 0.25), // Dark Gray
            
            // Other colors
            (1, 1, 1),          // White
            (0, 0, 0),          // Black
        ]
        
        return colors
    }

}
