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
        MarkedScrollView(scrollDirection: .horizontal) {
            HStack(spacing: 11){
                ForEach(categoryModels) { catModel in
                    Button {
                        pickedCategoryId = catModel.id!
                        
                        if !userHasChosenCat {
                            userHasChosenCat = true
                        }
                    } label: {
                        ZStack(alignment: .top) {
                            Text(catModel.name)
                                .frame(minWidth: 60)
                                .padding()
                                .bold()
                                .foregroundColor(ColorMaker.buildforegroundTextColor(catColor: catModel.color))
                                .background(catModel.buildColor())
                                .overlay(alignment: .top) {
                                    Rectangle()
                                        .foregroundColor(catModel.buildColor(colorShift: -0.15))
                                        .frame(height: 4)
                                        .opacity(catModel.id! == pickedCategoryId ? 1 : 0)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .offset(y: catModel.id! == pickedCategoryId ? 20  : 0)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .overlay(alignment: .leading) {
            if categoryModels.isEmpty {
                Text("No hay categorías")
                    .bold()
            }
        }
    }
}
