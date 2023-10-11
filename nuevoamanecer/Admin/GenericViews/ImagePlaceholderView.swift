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
    var radius: CGFloat = 100
    var fontSize: CGFloat = 28
    
    var body: some View {
        Text(firstName.prefix(1) + lastName.prefix(1))
            .textCase(.uppercase)
            .font(.system(size: fontSize))
            .fontWeight(.bold)
            .frame(width: radius, height: radius)
            .background(Color(.systemGray3))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
