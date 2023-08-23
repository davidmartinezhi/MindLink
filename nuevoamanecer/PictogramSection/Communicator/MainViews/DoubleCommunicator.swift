//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct DoubleCommunicator: View {
    var patientId: String
    
    @State var showingCommunicator1: Bool = true
    
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
    
    @State var appLock: AppLock = AppLock()
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Communicator 1 (base)
                Communicator(patientId: nil, voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 1 : 0)
                
                // Communicator 2 (del usuario)
                Communicator(patientId: patientId, voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 0 : 1)
            }
        }
        .environmentObject(self.appLock)
    }
}
