//
//  SingleCommunicator.swift
//  nuevoamanecer
//
//  Created by emilio on 12/06/23.
//

import SwiftUI

struct SingleCommunicator: View {
    var patient: Patient?
        
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
    @State var voiceAge: String = "Adulta"
    @State var onLeftOfSwitch: Bool = true
    
    @State var appLock: AppLock = AppLock()
    
    var body: some View {
        Communicator(patient: patient, title: patient?.buildPatientTitle(), voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, voiceAge: $voiceAge, showSwitchView: false, onLeftOfSwitch: $onLeftOfSwitch)
            .environmentObject(self.appLock)
    }
}
