//
//  DropDownCategoryPicker.swift
//  Comunicador
//
//  Created by emilio on 31/05/23.
//

import SwiftUI

struct DropDownCategoryPicker: View {
    var categoryModels: [CategoryModel]
    @Binding var pickedCategoryId: String
    
    @State private var isExpanded = false
    var dropDownButtonHeight: Double = 20
        
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                let catName: String? = categoryModels.filter({$0.id! == pickedCategoryId}).first?.name
                Text(catName == nil ? "Categoría" : catName!)
                    .foregroundColor(.primary)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.primary)
            }
            .frame(height: dropDownButtonHeight)
            .padding()
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(8)
            .overlay {
                if isExpanded {
                    VStack {
                        Spacer(minLength: dropDownButtonHeight)
                        ForEach(categoryModels) { catModel in
                            Button {
                                pickedCategoryId = catModel.id!
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            } label: {
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: 5)
                                        .frame(maxHeight: .infinity)
                                        .foregroundColor(Color(red: catModel.color.r, green: catModel.color.g, blue: catModel.color.b))
                                    
                                    Text(catModel.name)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.top, 8)
                }
            }
        }
    }
}
