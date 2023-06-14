//
//  MiscSearchBar.swift
//  Comunicador
//
//  Created by emilio on 28/05/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var searchBarWidth: Double
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar", text: $searchText)
                .foregroundColor(.black)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: searchBarWidth)
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        /*
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        }
         */
    }
}
