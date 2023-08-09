//
//  PageWhiteboardView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageBoardView: View {
    @Binding var pageModel: PageModel
    @ObservedObject var boardCache: BoardCache
        
    var pictoBaseWidth: CGFloat
    var pictoBaseHeight: CGFloat
    
    var isEditing: Bool
    
    var soundOn: Bool = false
    var voiceGender: String = "Femenina"
    var talkingSpeed: String = "Normal"
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<pageModel.pictogramsInPage.count, id: \.self){ i in
                    let pictoModel: PictogramModel? = boardCache.getPicto(pictoId: pageModel.pictogramsInPage[i].pictoId)
                    let catModel: CategoryModel? = pictoModel != nil ? boardCache.getCat(catId: pictoModel!.categoryId) : nil
                    
                    let performWhenDeleted: (PictogramInPage) -> Void = { pictoInPage in
                        if let pictoIndex: Int = self.pageModel.pictogramsInPage.firstIndex(of: pictoInPage){
                            self.pageModel.pictogramsInPage.remove(at: pictoIndex)
                        }
                    }
                    
                    if isEditing {
                        EditPictogramHolderView(pictoModel: pictoModel,
                                                catModel: catModel,
                                                pictoInPage: $pageModel.pictogramsInPage[i],
                                                performWhenDeleted: performWhenDeleted,
                                                pictoBaseWidth: pictoBaseWidth,
                                                pictoBaseHeight: pictoBaseWidth,
                                                spaceWidth: geo.size.width,
                                                spaceHeight: geo.size.height)
                    } else {
                        DisplayPictogramHolderView(pictoModel: pictoModel,
                                                   catModel: catModel,
                                                   pictoInPage: $pageModel.pictogramsInPage[i],
                                                   pictoBaseWidth: pictoBaseWidth,
                                                   pictoBaseHeight: pictoBaseHeight,
                                                   spaceWidth: geo.size.width,
                                                   spaceHeight: geo.size.height,
                                                   soundOn: soundOn,
                                                   voiceGender: voiceGender,
                                                   talkingSpeed: talkingSpeed)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .task {
            await boardCache.populateBoard(pictosInPage: pageModel.pictogramsInPage)
        }
    }
}
