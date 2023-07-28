//
//  DisplayPictogramHolderView.swift
//  nuevoamanecer
//
//  Created by emilio on 22/06/23.
//

import SwiftUI
import AVFoundation

struct DisplayPictogramHolderView: View {
    var pictoModel: PictogramModel?
    var catModel: CategoryModel?
    @Binding var pictoInPage: PictogramInPage
        
    var pictoBaseWidth: CGFloat
    var pictoBaseHeight: CGFloat
    var spaceWidth: CGFloat
    var spaceHeight: CGFloat
    
    var soundOn: Bool
    var voiceGender: String
    var talkingSpeed: String
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            if pictoModel == nil || catModel == nil {
                PictogramPlaceholderView()
            } else {
                Button {
                    let utterance = AVSpeechUtterance(string: pictoModel!.name)
                    
                    utterance.voice = voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                    
                    utterance.rate = talkingSpeed == "Normal" ? 0.5 : talkingSpeed == "Lenta" ? 0.3 : 0.7
                    
                    synthesizer.speak(utterance)
                } label: {
                    PictogramView(pictoModel: pictoModel!, catModel: catModel!, displayName: true, displayCatColor: true)
                }
                .allowsHitTesting(soundOn)
            }
        }
        .frame(width: pictoBaseWidth * pictoInPage.scale, height: pictoBaseHeight * pictoInPage.scale)
        .offset(x: (spaceWidth / 2) * pictoInPage.xOffset, y: (spaceHeight / 2) * pictoInPage.yOffset)
    }
}
