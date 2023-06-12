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
    @Binding var userHasChosenCat: Bool
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 11) {
                ForEach(categoryModels) { catModel in
                    Button {
                        pickedCategoryId = catModel.id!
                        if !userHasChosenCat {
                            userHasChosenCat = true 
                        }
                    } label: {
                        Text(catModel.name)
                            .padding()
                            .bold()
                            .foregroundColor(pickedCategoryId == catModel.id! ? ColorMaker.buildforegroundTextColor(r: catModel.color.r, g: catModel.color.g, b: catModel.color.b) : .black)
                            .background(pickedCategoryId == catModel.id! ? catModel.buildColor(colorShift: -0.2) : .white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
