//
//  MiscColorPickerView.swift
//  Comunicador
//
//  Created by emilio on 04/06/23.
//

import SwiftUI


struct colorInputSlider: View {
    var trackHeight: CGFloat
    var trackForeground: Color
    @Binding var inputNumber: Double // 0-1
    
    var body: some View {
        Slider(value: $inputNumber, in: 0...1)
            .frame(height: trackHeight)
            .tint(trackForeground)
    }
}

struct MiscColorPickerView: View {
    @Binding var red: Double // 0-1
    @Binding var green: Double // 0-1
    @Binding var blue: Double // 0-1
    
    var body: some View {
        GeometryReader {geo in
            HStack {
                Spacer()
                
                VStack(spacing: 40){
                    Spacer()
                    colorInputSlider(trackHeight: 20, trackForeground: .red, inputNumber: $red)
                    colorInputSlider(trackHeight: 20, trackForeground: .green, inputNumber: $green)
                    colorInputSlider(trackHeight: 20, trackForeground: .blue, inputNumber: $blue)
                    Spacer()
                }
                .frame(width: geo.size.width / 2)
                
                Rectangle()
                    .frame(width: geo.size.width / 2)
                    .foregroundColor(Color(red: red, green: green, blue: blue))
                    .cornerRadius(10)
                    .overlay(alignment: .center){
                        Text("\(Int(red * 255)) - \(Int(green * 255)) - \(Int(blue * 255))")
                            .font(.system(size: 30, weight: .bold))
                    }
                
                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding()
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(10)
        }
    }
}
