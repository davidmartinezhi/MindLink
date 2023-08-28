//
//  PictogramEditor.swift
//  Comunicador
//
//  Created by emilio on 27/05/23.
//

import SwiftUI
import AVFoundation

struct Communicator: View {
    let patient: Patient?
    let title: String? 
    
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var searchingPicto: Bool = true
    @State var pickedCategoryId: String = ""
    
    @State var isConfiguring = false
    @Binding var voiceGender: String
    @Binding var talkingSpeed: String
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    @State var userHasChosenCat: Bool = false
        
    var showSwitchView: Bool
    @Binding var onLeftOfSwitch: Bool
    
    @EnvironmentObject var appLock: AppLock
    
    init(patient: Patient?, title: String?, voiceGender: Binding<String>, talkingSpeed: Binding<String>, showSwitchView: Bool = false, onLeftOfSwitch: Binding<Bool>){
        self.patient = patient
        self.title = title 
        let pictoCollectionPath: String = patient != nil ? "User/\(patient!.id)/pictograms" : "basePictograms"
        let catCollectionPath: String = patient != nil ? "User/\(patient!.id)/categories" : "baseCategories"

        self._pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        self._catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
        self._voiceGender = voiceGender
        self._talkingSpeed = talkingSpeed
        self.showSwitchView = showSwitchView
        self._onLeftOfSwitch = onLeftOfSwitch
    }
    
    var body: some View {
        let currCatColor: Color? = catVM.getCat(catId: pickedCategoryId)?.buildColor()
        let pictosInScreen: [PictogramModel] = searchText.isEmpty || !searchingPicto ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        let catsInScreen: [CategoryModel] = searchText.isEmpty || searchingPicto ? catVM.getCats() : catVM.getCats(nameFilter: searchText)
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    PictogramSearchBarView(searchText: $searchText, searchBarWidth: geo.size.width * 0.25, searchingPicto: $searchingPicto)
                        .onChange(of: searchText) { _ in
                            if !searchingPicto {
                                // Se hace el filtrado por nombre dos veces. Esto quizás se podría evitar.
                                let catsInScreenIds: [String] = catVM.getCats(nameFilter: searchText).map {$0.id!}
                                if !catsInScreenIds.contains(pickedCategoryId) {
                                    pickedCategoryId = catsInScreenIds.first ?? ""
                                }
                            }
                        }
                    
                    if title != nil {
                        Text(title!)
                            .font(.system(size: 30))
                            .padding(.horizontal, 25)
                    }
                    
                    Spacer()
                    
                    ButtonView(text: "Configuración Voz", color: .blue, isDisabled: appLock.isLocked) {
                        //modal con opciones de velocidad de pronunciacion y genero de voz
                        isConfiguring = true
                    }
                    .opacity(appLock.isLocked ? 0 : 1)
                    .font(.headline)
                    .sheet(isPresented: $isConfiguring) {
                        VoiceConfigurationView(talkingSpeed: $talkingSpeed, voiceGender: $voiceGender)
                    }
                    
                    LockView()
                }
                .frame(height: 40)
                .background(Color.white)
                .padding(.vertical)
                .padding(.horizontal, 70)
                
                HStack(spacing: 15) {
                    Text("Categorias")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.gray)
                    
                    if showSwitchView {
                        SwitchView(onLeft: $onLeftOfSwitch, leftText: "Base", rightText: "Personal", width: 200)
                    }
                    
                    Divider()

                    HStack{
                        CategoryPickerView(categoryModels: catsInScreen, pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
                    }
                    .background(Color.white)
                    .padding([.leading, .top, .bottom])
                    
                    Spacer()
                }
                .frame(height: 60)
                .background(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Rectangle()
                    .frame(height: 20.0, alignment: .bottom)
                    .foregroundColor(currCatColor ?? Color(red: 0.9, green: 0.9, blue: 0.9))
                
                PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 165, pictoHeight: 165, isBeingFiltered: !searchText.isEmpty && searchingPicto)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: catVM.categories) { _ in
             if !userHasChosenCat {
                 pickedCategoryId = catVM.getFirstCat()?.id! ?? ""
             }
         }
        .navigationBarBackButtonHidden(appLock.isLocked)
    }
    
    private func buildPictoViewButtons(_ pictoModels: [PictogramModel]) -> [Button<PictogramView>] {
        var pictoButtons: [Button<PictogramView>] = []
        
        for pictoModel in pictoModels {
            pictoButtons.append(
                Button(action: {
                    //text to speech
                    let utterance = AVSpeechUtterance(string: pictoModel.name)
                    
                    utterance.voice = voiceGender == "Masculina" ? AVSpeechSynthesisVoice(identifier: "com.apple.eloquence.es-MX.Reed") : AVSpeechSynthesisVoice(language: "es-MX")
                    
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
