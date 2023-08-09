//
//  PageThumbnailView.swift
//  nuevoamanecer
//
//  Created by emilio on 20/06/23.
//

import SwiftUI

struct PageThumbnail: View {
    @State var pageModel: PageModel
    @ObservedObject var boardCache: BoardCache
    
    init(pageModel: PageModel, boardCache: BoardCache){
        _pageModel = State(wrappedValue: pageModel)
        self.boardCache = boardCache
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                PageBoardView(pageModel: $pageModel, boardCache: boardCache, pictoBaseWidth: 40, pictoBaseHeight: 40, isEditing: false)
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
