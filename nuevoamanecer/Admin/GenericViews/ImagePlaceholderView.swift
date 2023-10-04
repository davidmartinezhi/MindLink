//
//  ImagePlaceholderView.swift
//  nuevoamanecer
//
//  Created by emilio on 03/10/23.
//

import SwiftUI

struct ImagePlaceholderView: View {
    var firstName: String
    var lastName: String
    
    var body: some View {
        Text(firstName.prefix(1) + lastName.prefix(1))
            .textCase(.uppercase)
            .font(.title)
            .fontWeight(.bold)
            .frame(width: 100, height: 100)
            .background(Color(.systemGray3))
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding(.trailing)
    }
}
