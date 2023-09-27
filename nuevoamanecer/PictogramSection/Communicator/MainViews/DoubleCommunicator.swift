//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct DoubleCommunicator: View {
    var patient: Patient
    
    @State var showingCommunicator1: Bool = true
    
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
    @State var voiceAge: String = "Adulta"
    
    @State var appLock: AppLock = AppLock()
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Communicator 1 (base)
                Communicator(patient: patient, title: patient.buildPatientTitle(), voiceGender: patient.voice.voiceGender, talkingSpeed: patient.voice.talkingSpeed, voiceAge: patient.voice.voiceAge, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 1 : 0)
                
                // Communicator 2 (del usuario)
                Communicator(patient: patient, title: patient.buildPatientTitle(), voiceGender: patient.voice.voiceGender, talkingSpeed: patient.voice.talkingSpeed, voiceAge: patient.voice.voiceAge, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 0 : 1)
            }
        }
        .environmentObject(self.appLock)
    }
}
