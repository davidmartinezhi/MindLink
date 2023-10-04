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
    var patientVM : PatientsViewModel = PatientsViewModel()
    var idPatient : String?
    @State var voiceConfig : VoiceConfiguration
    
    var speedList = ["Lenta", "Normal", "Rápida"]
    var voiceList = ["Masculina", "Femenina"]
    var voiceAgeList = ["Adulta", "Infantil"]
    
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    init(idPatient: String?, voiceConfig: VoiceConfiguration?) {
        self.idPatient = idPatient
        self._voiceConfig = State(initialValue: voiceConfig ?? VoiceConfiguration.defaultVoiceConfiguration())
    }
    
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
                    Picker("Género", selection: $voiceConfig.voiceGender) {
                        ForEach(voiceList, id: \.self) { voice in
                            Text(voice)
                        }
                    }
                } label: {
                    Text(voiceConfig.voiceGender)
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
                    Picker("Velocidad", selection: $voiceConfig.talkingSpeed) {
                        ForEach(speedList, id: \.self) { speed in
                            Text(speed)
                        }
                    }
                } label: {
                    Text(voiceConfig.talkingSpeed)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            
            HStack {
                Text("Edad de voz")
                    .font(.title2)
                Menu {
                    Picker("Edad", selection: $voiceConfig.voiceAge) {
                        ForEach(voiceAgeList, id: \.self) { age in
                            Text(age)
                        }
                    }
                } label: {
                    Text(voiceConfig.voiceAge)
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
                    
                    if (voiceConfig.voiceAge == "Infantil") {
                        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                        utterance.rate = 0.5
                        utterance.pitchMultiplier = 1.5
                    } else {
                        utterance.voice = voiceConfig.voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                        
                        utterance.rate = voiceConfig.talkingSpeed == "Normal" ? 0.5 : voiceConfig.talkingSpeed == "Lenta" ? 0.3 : 0.7
                    }
                    synthesizer.speak(utterance)
                }
                
                ButtonView(text: "Regresar", color: .blue) {
                    if (idPatient != nil) {
                        patientVM.updateConfiguration(idPatient: idPatient!, voiceConfig: voiceConfig) { err in
                            if err != nil {
                                // error
                            } else {
                                dismiss()
                            }
                        }
                    }
                    dismiss()
                }
            }
        }
    }
}
