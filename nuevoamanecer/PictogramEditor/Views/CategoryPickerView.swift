//
//  CategoryPickerView.swift
//  Comunicador
//
//  Created by emilio on 28/05/23.
//

import SwiftUI

struct CategoryPickerView: View {
    var categoryModels: [CategoryModel]
    @Binding var pickedCategoryId: String
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(categoryModels) { catModel in
                    Button {
                        pickedCategoryId = catModel.id!
                    } label: {
                        Text(catModel.name)
                            .padding()
                            .bold()
                            .foregroundColor(.black)
                            .background(pickedCategoryId == catModel.id! ? catModel.buildColor(colorShift: -0.2) : Color.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
