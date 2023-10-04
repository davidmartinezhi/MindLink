//
//  ChangeIndicatorView.swift
//  nuevoamanecer
//
//  Created by emilio on 03/10/23.
//

import SwiftUI

struct ChangeIndicatorView: View {
    var showIndicator: Bool
    
    var body: some View {
        Image(systemName: "largecircle.fill.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 10)
            .foregroundColor(.blue)
            .opacity(showIndicator ? 1 : 0)
    }
}
