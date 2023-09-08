//
//  LongPressButtonWithImageView.swift
//  nuevoamanecer
//
//  Created by emilio on 02/09/23.
//

import SwiftUI

struct LongPressButtonWithImage: View {
    var text: String
    var textSize: CGFloat = 15 
    var width: CGFloat
    var height: CGFloat = 40
    var background: Color
    var overlayedBackground: Color
    
    var systemNameImage: String
    var imagePosition: ImagePosition = .right
    var imagePadding: CGFloat = 10
    
    var isDisabled: Bool = false
    var action: () -> Void
    
    var longPressDuration: Double = 3 // Segundos
    @State var longPressProgress: Double = 0
    @GestureState var longPressState: Bool = false
                
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .updating($longPressState) { currState, prevState, _ in
                if prevState == false && currState == true { // Comienza a presionar
                    // Iniciar progreso
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        withAnimation{
                            longPressProgress += 0.1
                        }
                                
                        if longPressProgress >= longPressDuration {
                            longPressProgress = 0
                            timer.invalidate()
                            action()
                        } else if longPressState == false {
                            longPressProgress = 0
                            timer.invalidate()
                        }
                    }
                }
            
                prevState = currState
            }
    }
        
    private var viewContent: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(background)
                .cornerRadius(10)
                .overlay(alignment: .leading){
                    Rectangle()
                        .frame(width: width * (longPressProgress / longPressDuration), height: height)
                        .foregroundColor(overlayedBackground)
                        .cornerRadius(10)
                }
            
            HStack(spacing: 10) {
                if imagePosition == .left {
                    Image(systemName: systemNameImage)
                }
                
                Text(text)
                    .font(.system(size: textSize))
                
                if imagePosition == .right {
                    Image(systemName: systemNameImage)
                }
            }
            .padding(10)
            .frame(width: width)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        .frame(width: width)
    }
    
    var body: some View {
        if isDisabled {
            viewContent
        } else {
            viewContent
                .gesture(longPressGesture)
        }
    }
}
