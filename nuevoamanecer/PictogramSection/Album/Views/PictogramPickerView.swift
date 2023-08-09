//
//  PictogramPickerView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI
import AVFoundation

struct PictogramPickerView: View {
    @Binding var pickedPictos: [String:PictogramInPage] // [pictoId:PictogramModel]
    
    @StateObject var pictoVM: PictogramViewModel
    @StateObject var catVM: CategoryViewModel
    
    @State var searchText: String = ""
    @State var pickedCategoryId: String = ""
        
    @State var userHasChosenCat: Bool = false
        
    var showSwitchView: Bool
    @Binding var onLeftOfSwitch: Bool
        
    init(pickedPictos: Binding<[String:PictogramInPage]>, pictoCollectionPath: String, catCollectionPath: String, showSwitchView: Bool = false, onLeftOfSwitch: Binding<Bool>){
        _pickedPictos = pickedPictos
        _pictoVM = StateObject(wrappedValue: PictogramViewModel(collectionPath: pictoCollectionPath))
        _catVM = StateObject(wrappedValue: CategoryViewModel(collectionPath: catCollectionPath))
        self.showSwitchView = showSwitchView
        _onLeftOfSwitch = onLeftOfSwitch
    }
    
    var body: some View {
        let currCatColor: Color? = catVM.getCat(catId: pickedCategoryId)?.buildColor()
        let pictosInScreen: [PictogramModel] = searchText.isEmpty ? pictoVM.getPictosFromCat(catId: pickedCategoryId) :
        pictoVM.getPictosFromCat(catId: pickedCategoryId, nameFilter: searchText)
        
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    SearchBarView(searchText: $searchText, placeholder: "Buscar Pictograma", searchBarWidth: geo.size.width * 0.30, backgroundColor: .white)
                    Spacer()
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
                        CategoryPickerView(categoryModels: catVM.getCats(), pickedCategoryId: $pickedCategoryId, userHasChosenCat: $userHasChosenCat)
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
                
                PictogramGridView(pictograms: buildPictoViewButtons(pictosInScreen), pictoWidth: 165, pictoHeight: 165, isBeingFiltered: !searchText.isEmpty)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: catVM.categories) { _ in
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
                    if pickedPictos[pictoModel.id!] == nil {
                        pickedPictos[pictoModel.id!] = PictogramInPage(pictoId: pictoModel.id!, isBasePicto: onLeftOfSwitch)
                    } else {
                        pickedPictos.removeValue(forKey: pictoModel.id!)
                    }
                }, label: {
                    PictogramView(pictoModel: pictoModel,
                                  catModel: catVM.getCat(catId: pictoModel.categoryId)!,
                                  displayName: true,
                                  displayCatColor: false,
                                  overlayImage: pickedPictos[pictoModel.id!] != nil ? Image(systemName: "checkmark.circle") : nil,
                                  overlayImageColor: .blue,
                                  overlyImageOpacity: 0.8)
                })
            )
        }
        return pictoButtons
    }
}
