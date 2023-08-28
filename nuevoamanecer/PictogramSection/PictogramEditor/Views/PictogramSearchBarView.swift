//
//  PictogramSearchBarView.swift
//  nuevoamanecer
//
//  Created by emilio on 26/08/23.
//

import SwiftUI

struct PictogramSearchBarView: View {
    @Binding var searchText: String
    let searchBarWidth: Double
    @Binding var searchingPicto: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.gray)
                .padding([.bottom, .top, .leading])
            
            ZStack(alignment: .leading) {
                TextField("", text: $searchText)
                    .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Buscar")
                        .opacity(0.5)
                        .allowsHitTesting(false)
                    
                    Button {
                        searchingPicto.toggle()
                    } label: {
                        HStack {
                            Text(searchingPicto ? "pictograma" : "categoría")
                                .bold()
                        }
                    }
                }
                .opacity(searchText.isEmpty ? 1 : 0)
                .allowsHitTesting(searchText.isEmpty)
                    
            }
            .padding([.bottom, .top, .trailing])
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
            }
        }
        .frame(width: searchBarWidth)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
