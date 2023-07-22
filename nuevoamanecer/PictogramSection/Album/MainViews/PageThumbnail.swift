//
//  PageThumbnailView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageThumbnail: View {
    @State var pageModel: PageModel
    @ObservedObject var pictoCache: PictogramCache
    @ObservedObject var catCache: CategoryCache
    
    init(pageModel: PageModel, pictoCache: PictogramCache, catCache: CategoryCache){
        _pageModel = State(wrappedValue: pageModel)
        self.pictoCache = pictoCache
        self.catCache = catCache
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                PageBoardView(pageModel: $pageModel, pictoCache: pictoCache, catCache: catCache, isEditing: false, soundOn: false, pictoBaseWidth: 40, pictoBaseHeight: 40)
                    .border(.gray)
                
                Text("\(pageModel.name)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 10)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
