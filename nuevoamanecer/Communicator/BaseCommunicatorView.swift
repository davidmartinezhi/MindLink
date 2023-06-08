//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct BaseCommunicatorView: View {
    // @StateObject var basePictoVM: PictogramViewModel = PictogramViewModel(collectionPath: "basePictograms")
    // @StateObject var baseCatVM: CategoryViewModel = CategoryViewModel(collectionPath: "baseCategories")
    // "users/user_id/pictograms"
    // "users/user_id/categories"
    @StateObject var userPictoVM: PictogramViewModel = PictogramViewModel(collectionPath: "basePictograms")
    @StateObject var userCatVM: CategoryViewModel = CategoryViewModel(collectionPath: "baseCategories")
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
    
    @State var isConfiguring = false
    @State var isBlocked = true
    
    @State var voiceGender = "Masculina"
    @State var talkingSpeed = "Normal"
    
    let synthesizer = AVSpeechSynthesizer()
    
        
    var body: some View {
        let currCatColor: Color? = userCatVM.getCat(catId: pickedCategoryId)?.buildColor()
        
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        ButtonView(text: "Iniciar Sesión", color: .blue, isDisabled: isBlocked) {
                            //vista de autenticacion
                        }
                        
                        Spacer()
                        
                        ButtonView(text: "Configuración Voz", color: .blue, isDisabled: isBlocked) {
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
                        
                        CategoryPickerView(categoryModels: userCatVM.getCats(), pickedCategoryId: $pickedCategoryId)
                        
                        Image(systemName: isBlocked ? "lock.filled" : "lock.open.filled")
                            .gesture(
                                LongPressGesture(minimumDuration: isBlocked ? 5 : 0.1)
                                    .onEnded({ value in
                                        isBlocked.toggle()
                                    })
                            )
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 60)
                    .background(currCatColor ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                    
                    PictogramGridView(pictograms: buildPictoViewButtons(searchText.isEmpty ? userPictoVM.getPictosFromCat(catId: pickedCategoryId) :
                                                                            userPictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)),
                                      pictoWidth: 200, pictoHeight: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
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
                                  catModel: userCatVM.getCat(catId: pictoModel.categoryId)!,
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
