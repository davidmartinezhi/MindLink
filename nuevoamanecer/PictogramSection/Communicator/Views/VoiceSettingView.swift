//
//  VoiceConfigurationView.swift
//  Comunicador
//
//  Created by Alumno on 05/06/23.
//

import SwiftUI
import AVFoundation

struct VoiceSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    var voiceAgeList = ["Adulta", "Infantil"]
    var speedList = ["Lenta", "Normal", "Rápida"]
    var voiceList = ["Masculina", "Femenina"]
    
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @Binding var voiceSetting: VoiceSetting
    @State var voiceSettingCapture: VoiceSetting
    
    var voiceSettingVM: VoiceSettingViewModel = VoiceSettingViewModel()
    
    init(voiceSetting: Binding<VoiceSetting>){
        self._voiceSetting = voiceSetting
        self._voiceSettingCapture = State(initialValue: voiceSetting.wrappedValue)
    }
    
    var body: some View {
        
        VStack{
            VStack{
                Text("Configuración de voz")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                Text("La configuración que elijas se quedará guardada y aplicada.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            .padding(20)
            .padding(.top, 30)

            Form {
                Section(header: Text("Configuración")) {
                    
                    Picker("Tipo de voz", selection: $voiceSetting.voiceAge) {
                        ForEach(voiceAgeList, id: \.self) { age in
                            Text(age)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    if(voiceSetting.voiceAge == "Adulta"){
                        Picker("Género", selection: $voiceSetting.voiceGender) {
                            ForEach(voiceList, id: \.self) { voice in
                                Text(voice)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    
                    Picker("Velocidad de pronunciación", selection: $voiceSetting.talkingSpeed) {
                        ForEach(speedList, id: \.self) { speed in
                            Text(speed)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    

                }
                
                HStack{
                    /*
                    //Cancel
                    Button(action: {
                        dismiss()
                    }){
                        HStack {
                            Text("Cerrar")
                                .font(.headline)
                                
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                     */
                    
                    
                    //Probar
                    Button(action: {
                        //text to speech
                        let utterance = AVSpeechUtterance(string: "Nuevo Amanecer")

                        if (voiceSetting.voiceAge == "Infantil") {
                            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                            utterance.rate = 0.5
                            utterance.pitchMultiplier = 1.5
                        } else {
                            utterance.voice = voiceSetting.voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                            
                            utterance.rate = voiceSetting.talkingSpeed == "Normal" ? 0.5 : voiceSetting.talkingSpeed == "Lenta" ? 0.3 : 0.7
                        }

                        synthesizer.speak(utterance)
                    }){
                        HStack {
                            Text("Probar")
                                .font(.headline)
                                
                            Spacer()
                            Image(systemName: "speaker.wave.2")
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    /*
                    ButtonWithImageView(text: "Probar", width: 157, systemNameImage: "speaker.wave.2", background: .green) {
                        //text to speech
                        let utterance = AVSpeechUtterance(string: "Nuevo Amanecer")

                        if (voiceSetting.voiceAge == "Infantil") {
                            utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                            utterance.rate = 0.5
                            utterance.pitchMultiplier = 1.5
                        } else {
                            utterance.voice = voiceSetting.voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                            
                            utterance.rate = voiceSetting.talkingSpeed == "Normal" ? 0.5 : voiceSetting.talkingSpeed == "Lenta" ? 0.3 : 0.7
                        }

                        synthesizer.speak(utterance)
                    }
                     */
                }
            }
        }
        /*
        VStack {

            
            Spacer()
                .frame(height: 40)
            
            HStack {
                Text("Género de voz")
                    .font(.title2)
                
                Spacer()
                Menu {
                    Picker("Género", selection: $voiceSetting.voiceGender) {
                        ForEach(voiceList, id: \.self) { voice in
                            Text(voice)
                        }
                    }
                } label: {
                    Text(voiceSetting.voiceGender)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            .padding(20)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("Velocidad de pronunciación")
                    .font(.title2)
                Spacer()
                Menu {
                    Picker("Velocidad", selection: $voiceSetting.talkingSpeed) {
                        ForEach(speedList, id: \.self) { speed in
                            Text(speed)
                        }
                    }
                } label: {
                    Text(voiceSetting.talkingSpeed)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            .padding(20)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("Tipo de voz")
                    .font(.title2)
                Spacer()
                Menu {
                    Picker("Tipo", selection: $voiceSetting.voiceAge) {
                        ForEach(voiceAgeList, id: \.self) { age in
                            Text(age)
                        }
                    }
                } label: {
                    Text(voiceSetting.voiceAge)
                        .font(.title2)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.primary)
            }
            .padding(20)
            
            HStack {
                ButtonWithImageView(text: "Probar", systemNameImage: "speaker.wave.2", background: .gray) {
                    //text to speech
                    let utterance = AVSpeechUtterance(string: "Nuevo Amanecer")

                    if (voiceSetting.voiceAge == "Infantil") {
                        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                        utterance.rate = 0.5
                        utterance.pitchMultiplier = 1.5
                    } else {
                        utterance.voice = voiceSetting.voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                        
                        utterance.rate = voiceSetting.talkingSpeed == "Normal" ? 0.5 : voiceSetting.talkingSpeed == "Lenta" ? 0.3 : 0.7
                    }

                    synthesizer.speak(utterance)
                }
                
                ButtonView(text: "Regresar", color: .blue) {
                    dismiss()
                }
            }
        }
         */
        .onDisappear {
            if voiceSetting.patientId != nil && voiceSetting != voiceSettingCapture {
                if voiceSetting.id != nil {
                    voiceSettingVM.editVoiceSetting(voiceSettingId: voiceSetting.id!, voiceSetting: voiceSetting) { error in
                        if error != nil {
                            // Error
                        }
                    }
                } else {
                    voiceSettingVM.createVoiceSetting(voiceSetting: voiceSetting) { error, id in
                        if error != nil || id == nil {
                            // Error
                        } else {
                            voiceSetting.id = id!
                        }
                    }
                }
            } 
        }
    }
}
