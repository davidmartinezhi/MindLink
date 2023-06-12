//
//  MiscColorPickerView.swift
//  Comunicador
//
//  Created by emilio on 04/06/23.
//

import SwiftUI

struct ColorInputSlider: View {
    var trackHeight: CGFloat
    var trackForeground: Color
    @Binding var inputNumber: Double // 0-1
    
    var body: some View {
        Slider(value: $inputNumber, in: 0...1)
            .frame(height: trackHeight)
            .tint(trackForeground)
    }
}

struct ColorPickerView: View {
    @Binding var red: Double // 0-1
    @Binding var green: Double // 0-1
    @Binding var blue: Double // 0-1
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20){
                ScrollView(.horizontal){
                    let basicColors: [(r: Double, g: Double, b: Double)] = ColorMaker.getBasicColors()
                    HStack(spacing: 0) {
                        ForEach(0..<basicColors.count, id: \.self){ i in
                            Button {
                                red = basicColors[i].r
                                green = basicColors[i].g
                                blue = basicColors[i].b
                            } label: {
                                Rectangle()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color(red: basicColors[i].r, green: basicColors[i].g, blue: basicColors[i].b))
                            }
                        }
                    }
                }
                .cornerRadius(10)
                
                HStack(spacing: 15){
                    VStack(spacing: 20){
                        Spacer()
                        ColorInputSlider(trackHeight: 20, trackForeground: .red, inputNumber: $red)
                        ColorInputSlider(trackHeight: 20, trackForeground: .green, inputNumber: $green)
                        ColorInputSlider(trackHeight: 20, trackForeground: .blue, inputNumber: $blue)
                        Spacer()
                    }
                    .frame(width: geo.size.width * 0.45)
                    
                    Rectangle()
                        .frame(width: geo.size.width * 0.45)
                        .foregroundColor(Color(red: red, green: green, blue: blue))
                        .cornerRadius(10)
                        .overlay(alignment: .center){
                            Text("\(Int(red * 255)) - \(Int(green * 255)) - \(Int(blue * 255))")
                                .font(.system(size: geo.size.width * 0.05, weight: .bold))
                                .foregroundColor(ColorMaker.buildforegroundTextColor(r: red, g: green, b: blue))
                        }
                }
            }
            .padding()
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(10)
        }
    }
}
