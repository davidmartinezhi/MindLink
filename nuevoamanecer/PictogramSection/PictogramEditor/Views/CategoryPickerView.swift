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
                        let categoryBGColor: CategoryColor = catModel.buildColorCatColor(colorShift: -0.2)
                        let categoryFGColor: Color = ColorMaker.buildforegroundTextColor(catColor: categoryBGColor)
                        
                        Text(catModel.name)
                            .frame(minWidth: 60)
                            .padding()
                            .bold()
                            .foregroundColor(pickedCategoryId == catModel.id! ? categoryFGColor : .black)
                            .background(pickedCategoryId == catModel.id! ? catModel.buildColor(colorShift: -0.2) : .white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
