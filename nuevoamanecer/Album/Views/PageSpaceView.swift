//
//  PageView.swift
//  nuevoamanecer
//
//  Created by emilio on 08/06/23.
//

import SwiftUI

struct PageSpaceView: View {
    @Binding var pageModel: PageModel
    let allowGestures: Bool
    let allowSound: Bool
    var albumPictoVM: AlbumPictogramViewModel
    var albumCatVM: AlbumCategoryViewModel
    
    @State var pictoModels: [String:PictogramModel]?
    @State var catModels: [String:CategoryModel]?
    
    var body: some View {
        GeometryReader{ geo in
            ZStack {
                ForEach(){
                    
                }
            }
        }
        .background(.white)
        .task {
            pictoModels = await albumPictoVM.getPictos(pictoIds: pageModel.pictogramsInPage.map{$0.pictoId})
            if pictoModels == nil {
                // Error
            } else {
                // catModels = await albumCatVM.getCats(catIds: pict)
            }
        }
    }
}

struct PageSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        Text("...")
    }
}
