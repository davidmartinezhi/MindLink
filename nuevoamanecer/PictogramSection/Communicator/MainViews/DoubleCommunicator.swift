//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct DoubleCommunicator: View {
    var pictoCollectionPath1: String
    var catCollectionPath1: String
    var pictoCollectionPath2: String
    var catCollectionPath2: String
    
    @State var showingCommunicator1: Bool = true
    
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
        
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Communicator 1
                Communicator(pictoCollectionPath: pictoCollectionPath1, catCollectionPath: catCollectionPath1, voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 1 : 0)
                
                // Communicator 2
                Communicator(pictoCollectionPath: pictoCollectionPath2, catCollectionPath: catCollectionPath2, voiceGender: $voiceGender, talkingSpeed: $talkingSpeed, showSwitchView: true, onLeftOfSwitch: $showingCommunicator1)
                .zIndex(showingCommunicator1 ? 0 : 1)
            }
        }
    }
}
