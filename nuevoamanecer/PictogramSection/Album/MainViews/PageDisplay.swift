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
    @ObservedObject var pictoCache: PictogramCache
    @ObservedObject var catCache: CategoryCache
    
    @State var soundOn: Bool = true
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack(spacing: 15) {
                    Text(pageModel.name)
                        .font(.system(size: 30, weight: .bold))
                    
                    Spacer()
                    
                    ButtonWithImageView(text: soundOn ? "Desactivar Sonido" : "Activar Sonido", systemNameImage: soundOn ? "speaker.slash" : "speaker"){
                        soundOn.toggle()
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 70)
                
                Divider()
                
                PageBoardView(pageModel: $pageModel, pictoCache: pictoCache, catCache: catCache, isEditing: false, soundOn: soundOn, pictoBaseWidth: 200, pictoBaseHeight: 200)
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
    }
}
