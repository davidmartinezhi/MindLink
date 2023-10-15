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
                    ZStack {
                        let catIsSelected: Bool = catModel.id! == pickedCategoryId
                        
                        CategoryButtonTextView(catName: catModel.name, foregroundColor: Color.clear, background: catModel.buildColor())
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .scaleEffect(y: catIsSelected ? 2 : 1, anchor: .top)
                        
                        CategoryButtonTextView(catName: catModel.name, foregroundColor: ColorMaker.buildforegroundTextColor(catColor: catModel.color), background: catModel.buildColor())
                            .overlay(alignment: .top) {
                                Rectangle()
                                    .foregroundColor(catModel.buildColor(colorShift: catModel.color.isBright() ? -0.15 : 0.15))
                                    .frame(height: 5)
                                    .opacity(catIsSelected ? 1 : 0)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onAppear {
                                print(catModel.color.isBright())
                            }
                    }
                    .onTapGesture {
                        pickedCategoryId = catModel.id!
                        
                        if !userHasChosenCat {
                            userHasChosenCat = true
                        }
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

struct CategoryButtonTextView: View {
    let catName: String
    let foregroundColor: Color
    let background: Color
    
    var body: some View {
        Text(catName)
            .frame(minWidth: 60)
            .padding()
            .bold()
            .foregroundColor(foregroundColor)
            .background(background)
    }
}
