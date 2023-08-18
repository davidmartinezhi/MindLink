//
//  VoiceConfigurationView.swift
//  Comunicador
//
//  Created by Alumno on 05/06/23.
//

import SwiftUI
import AVFoundation

struct VoiceConfigurationView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var talkingSpeed : String
    var speedList = ["Lenta", "Normal", "Rápida"]
    @Binding var voiceGender : String
    var voiceList = ["Masculina", "Femenina"]
    
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            Text("Configuración de voz")
                .font(.largeTitle.bold())
            
            Spacer()
                .frame(height: 40)
            
            HStack {
                Text("Género de voz")
                    .font(.title2)
                Menu {
                    Picker("Género", selection: $voiceGender) {
                        ForEach(voiceList, id: \.self) { voice in
                            Text(voice)
                        }
                    }
                } label: {
                    Text(voiceGender)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("Velocidad de Pronunciación")
                    .font(.title2)
                Menu {
                    Picker("Velocidad", selection: $talkingSpeed) {
                        ForEach(speedList, id: \.self) { speed in
                            Text(speed)
                        }
                    }
                } label: {
                    Text(talkingSpeed)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            
            HStack {
                ButtonWithImageView(text: "Probar", systemNameImage: "speaker.wave.2", background: .gray) {
                    let utterance = AVSpeechUtterance(string: "Nuevo Amanecer")
                    
                    utterance.voice = voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                    
                    utterance.rate = talkingSpeed == "Normal" ? 0.5 : talkingSpeed == "Lenta" ? 0.3 : 0.7
                    
                    synthesizer.speak(utterance)
                }
                
                ButtonView(text: "Regresar", color: .blue) {
                    dismiss()
                }
            }
        }
    }
}

struct VoiceConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceConfigurationView(talkingSpeed: .constant("Normal"), voiceGender: .constant("Masculina"))
    }
}
