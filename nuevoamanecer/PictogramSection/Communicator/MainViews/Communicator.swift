//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct Communicator: View {
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isConfiguring = false
    @Binding var voiceGender: String
    @Binding var talkingSpeed: String
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @State var userHasChosenCat: Bool = false
    
    @Binding var isLocked: Bool
    
    init(pictoCollectionPath: String, catCollectionPath: String, voiceGender: Binding<String>, talkingSpeed: Binding<String>, isLocked: Binding<Bool>){
        _pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        _catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
        _voiceGender = voiceGender
        _talkingSpeed = talkingSpeed
        _isLocked = isLocked
    }
    
    var body: some View {
        let currCatColor: Color? = catVM.getCat(catId: pickedCategoryId)?.buildColor()
        let pictosInScreen: [PictogramModel] = searchText.isEmpty ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        /*
                        ButtonView(text: "Iniciar Sesión", color: .blue) {
                            //vista de autenticacion
                        }
                         */ 
                        
                        Spacer()
                        
                        ButtonView(text: "Configuración Voz", color: .blue, isDisabled: isLocked) {
                            //modal con opciones de velocidad de pronunciacion y genero de voz
                            isConfiguring = true
                        }
                        .sheet(isPresented: $isConfiguring) {
                            VoiceConfigurationView(talkingSpeed: $talkingSpeed, voiceGender: $voiceGender)
                        }
                    }
                    .frame(height: 40)
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    HStack(spacing: 25) {
                        SearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                        
                        CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                        
                        Spacer()
                        
                        LockView(isLocked: $isLocked)
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(currCatColor ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 200, pictoHeight: 200)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onReceive(catVM.objectWillChange) { _ in
             if pickedCategoryId.isEmpty || !userHasChosenCat {
                 pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
             }
         }
    }
    
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    //text to speech
                    let utterance = AVSpeechUtterance(string: pictoModel.name)
                    
                    if (voiceGender == "Masculina") {
                        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed")
                    } else {
                        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
                    }
                    
                    utterance.rate = talkingSpeed == "Normal" ? 0.5 : talkingSpeed == "Lenta" ? 0.3 : 0.7
                    
                    synthesizer.speak(utterance)

                }, label: {
                    PictogramView(pictoModel: pictoModel,
                                  catModel: catVM.getCat(catId: pictoModel.categoryId)!,
                                  displayName: true,
                                  displayCatColor: false,
                                  overlayImage: Image(systemName: "speaker.wave.3.fill"),
                                  overlayImageColor: .gray,
                                  overlyImageOpacity: 0.2)
                })
            )
        }
        return pictoButtons
    }
}