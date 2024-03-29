//
//  PageOptionsView.swift
//  nuevoamanecer
//
//  Created by emilio on 21/07/23.
//

import SwiftUI

struct VerticalEllipsisView: View {
    var body: some View {
        VStack(spacing: 3) {
            Circle()
                .frame(width: 6, height: 6)
            Circle()
                .frame(width: 6, height: 6)
            Circle()
                .frame(width: 6, height: 6)
        }
    }
}

struct PageOptionsView: View {
    var pageId: String
    @Binding var showingOptionsOf: String?
    
    var patientId: String
    @ObservedObject var pageVM: PageViewModel
    var pageModel: PageModel
    @ObservedObject var boardCache: BoardCache
    
    var performWhenDeleted: () -> Void

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 15) {
                Button {
                    if showingOptionsOf != pageId {
                        showingOptionsOf = pageId
                    } else {
                        showingOptionsOf = nil
                    }
                } label: {
                    VStack {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .opacity(0.6)
                    }
                    .frame(width: geo.size.width *  0.8, height: 10)
                }
                
                if showingOptionsOf == pageId {
                    VStack(spacing: 10) {
                        NavigationLink {
                            PageEdit(patientId: patientId, pageVM: pageVM, pageModel: pageModel, boardCache: boardCache)
                        } label: {
                            HStack(spacing: 20) {
                                Text("Editar")
                                    .foregroundColor(.white)
                                    .bold()
                                
                                Image(systemName: "pencil")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                            }
                            .padding(10)
                            .frame(width: geo.size.width, height: 50)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        ButtonWithImageView(text: "Eliminar", systemNameImage: "trash", background: .red) {
                            performWhenDeleted()
                        }
                    }
                }
            }
            .padding()
            .frame(width: geo.size.width)
        }
    }
}
