//
//  SingleCommunicator.swift
//  nuevoamanecer
//
//  Created by emilio on 12/06/23.
//

import SwiftUI

struct SingleCommunicator: View {
    var patient: Patient?
        
    @State var onLeftOfSwitch: Bool = true
    
    @State var appLock: AppLock = AppLock()
    
    @State var voiceSetting: VoiceSetting = VoiceSetting.defaultVoiceSetting()
    var voiceSettingVM: VoiceSettingViewModel = VoiceSettingViewModel()
    
    var body: some View {
        Communicator(patient: patient, title: patient?.buildPatientTitle(), showSwitchView: false, onLeftOfSwitch: $onLeftOfSwitch, voiceSetting: $voiceSetting)
            .environmentObject(self.appLock)
            .onAppear {
                if patient == nil {
                    voiceSetting = VoiceSetting.defaultVoiceSetting()
                } else {
                    voiceSettingVM.getVoiceSetting(patientId: patient!.id) { error, voiceSetting in
                        if error != nil || voiceSetting == nil {
                            self.voiceSetting = VoiceSetting.defaultVoiceSetting(patientId: patient!.id)
                        } else {
                            self.voiceSetting = voiceSetting!
                        }
                    }
                }
            }
    }
}
