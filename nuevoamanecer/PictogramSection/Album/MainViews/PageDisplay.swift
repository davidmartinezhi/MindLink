//
//  PageView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageDisplay: View {
    var patientId: String
    @ObservedObject var pageVM: PageViewModel
    @State var pageModel: PageModel
    @ObservedObject var boardCache: BoardCache
    
    @State var isConfiguringVoice: Bool = false
    @State var soundOn: Bool = true
    @State var voiceGender: String = "Femenina"
    @State var talkingSpeed: String = "Normal"
    @State var voiceAge: String = "Adulta"
    
    @EnvironmentObject var appLock: AppLock
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 15) {
                    Text(pageModel.name)
                        .font(.system(size: 30, weight: .bold))
                    
                    Spacer()
                    
                    ButtonWithImageView(text: soundOn ? "Desactivar Sonido" : "Activar Sonido", systemNameImage: soundOn ? "speaker.slash" : "speaker", isDisabled: appLock.isLocked){
                        soundOn.toggle()
                    }
                    
                    ButtonView(text: "Configuración Voz", color: .blue, isDisabled: appLock.isLocked) {
                        //modal con opciones de velocidad de pronunciacion y genero de voz
                        isConfiguringVoice = true
                    }
                    .font(.headline)
                    .sheet(isPresented: $isConfiguringVoice) {
                        VoiceConfigurationView(idPatient: patientId, voiceConfig: VoiceConfiguration())
                    }
                    
                    LockView()
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Divider()
                
                PageBoardView(pageModel: $pageModel, boardCache: boardCache, pictoBaseWidth: 200, pictoBaseHeight: 200, isEditing: false, soundOn: soundOn, voiceGender: voiceGender, talkingSpeed: talkingSpeed)
            }
        }
        .onAppear {
            pageVM.updatePageLastOpenedAt(pageId: pageModel.id!) { error in
                if error != nil {
                    // Error
                } else {
                    // Exito
                }
            }
        }
        .navigationBarBackButtonHidden(appLock.isLocked)
    }
}
