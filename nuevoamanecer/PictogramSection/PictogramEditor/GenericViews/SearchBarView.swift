//
//  MiscSearchBar.swift
//  Comunicador
//
//  Created by emilio on 28/05/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    var searchBarWidth: Double
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.gray)
                .padding([.bottom, .top, .leading])
            
            TextField(placeholder, text: $searchText)
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
