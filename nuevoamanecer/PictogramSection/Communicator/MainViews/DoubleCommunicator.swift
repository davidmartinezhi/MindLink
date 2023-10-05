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
        
    @State var appLock: AppLock = AppLock()
    
    @State var voiceSetting: VoiceSetting = VoiceSetting.defaultVoiceSetting()
    var voiceSettingVM: VoiceSettingViewModel = VoiceSettingViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Communicator 1 (base)
                Communicator(patient: nil, title: patient.buildPatientTitle(), showSwitchView: true, onLeftOfSwitch: $showingCommunicator1, voiceSetting: $voiceSetting)
                .zIndex(showingCommunicator1 ? 1 : 0)
                
                // Communicator 2 (del usuario)
                Communicator(patient: patient, title: patient.buildPatientTitle(), showSwitchView: true, onLeftOfSwitch: $showingCommunicator1, voiceSetting: $voiceSetting)
                .zIndex(showingCommunicator1 ? 0 : 1)
            }
        }
        .environmentObject(self.appLock)
        .onAppear {
            voiceSettingVM.getVoiceSetting(patientId: patient.id) { error, voiceSetting in
                if error != nil || voiceSetting == nil {
                    self.voiceSetting = VoiceSetting.defaultVoiceSetting(patientId: patient.id)
                } else {
                    self.voiceSetting = voiceSetting!
                }
            }
        }
    }
}
