//
//  LockView.swift
//  nuevoamanecer
//
//  Created by emilio on 12/06/23.
//

import SwiftUI

struct LockView: View {
    @EnvironmentObject var appLock: AppLock
    var width: CGFloat = 150
    var height: CGFloat = 40
    
    var longPressDuration: Double = 3 // Segundos
    @State var longPressProgress: Double = 0
    @GestureState var longPressState: Bool = false
                
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: longPressDuration)
            .updating($longPressState) { currState, prevState, _ in
                if appLock.isLocked {
                    if prevState == false && currState == true { // Comienza a presionar
                        // Iniciar progreso
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            withAnimation{
                                longPressProgress += 0.1
                            }
                                    
                            if longPressProgress >= longPressDuration {
                                longPressProgress = 0
                                appLock.isLocked = false
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
                appLock.isLocked = true
            }
    }
    
    private var lockViewContent: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height)
                .foregroundColor(appLock.isLocked ? .gray : .blue)
                .cornerRadius(10)
                .overlay(alignment: .leading){
                    Rectangle()
                        .frame(width: width * (longPressProgress / longPressDuration), height: height)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
            
            HStack(spacing: 5) {
                Image(systemName: appLock.isLocked ? "lock.fill" : "lock.open.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(appLock.isLocked ? "Desbloquear" : "Bloquear")
            }
            .padding(10)
            .frame(width: width, height: height)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        .frame(width: width, height: height)
    }
    
    var body: some View {
        if appLock.isLocked {
            lockViewContent
                .gesture(longPressGesture)
        } else {
            lockViewContent
                .gesture(tapGesture)
        }

    }
}
