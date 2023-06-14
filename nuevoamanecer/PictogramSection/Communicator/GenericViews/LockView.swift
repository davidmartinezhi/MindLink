//
//  LockView.swift
//  nuevoamanecer
//
//  Created by emilio on 12/06/23.
//

import SwiftUI

struct LockView: View {
    @Binding var isLocked: Bool
    var width: CGFloat = 150
    var height: CGFloat = 30
    
    var longPressDuration: Double = 3 // Segundos
    @State var longPressProgress: Double = 0
    @GestureState var longPressState: Bool = false
                
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .updating($longPressState) { currState, prevState, _ in
                if isLocked {
                    if prevState == false && currState == true { // Comienza a presionar
                        // Iniciar progreso
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            withAnimation{
                                longPressProgress += 0.1
                            }
                                    
                            if longPressProgress >= longPressDuration {
                                longPressProgress = 0
                                isLocked = false
                                timer.invalidate()
                            } else if longPressState == false {
                                longPressProgress = 0
                                timer.invalidate()
                            }
                        }
                    }
                
                    prevState = currState
                }
            }
    }
    
    private var tapGesture: some Gesture {
        TapGesture(count: 1)
            .onEnded {
                isLocked = true
            }
    }
    
    private var lockViewContent: some View {
        
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(alignment: .leading){
                    Rectangle()
                        .frame(width: width * (longPressProgress / longPressDuration), height: height)
                        .foregroundColor(.green)
                        .cornerRadius(10)
                }
            
            HStack(spacing: 5) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(isLocked ? "Desbloquear" : "Bloquear")
            }
            .padding(10)
            .frame(width: width, height: height)
            .background(!isLocked ? Color.blue : nil)
            .foregroundColor(!isLocked ? Color.white : Color.blue)
            .cornerRadius(10)
        }
        .frame(width: width, height: height)
    }
    
    var body: some View {
        if isLocked {
            lockViewContent
                .gesture(longPressGesture)
        } else {
            lockViewContent
                .gesture(tapGesture)
        }

    }
}
