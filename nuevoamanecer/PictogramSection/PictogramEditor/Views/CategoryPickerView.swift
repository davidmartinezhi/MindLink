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
    
    @State var scrollOffset: Double = 0
    let coordinateSpaceName: String = "CategoryPickerViewCoordSpace"
    
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 11){
                ForEach(categoryModels) { catModel in
                    Button {
                        pickedCategoryId = catModel.id!
                        if !userHasChosenCat {
                            userHasChosenCat = true
                        }
                    } label: {                        
                        Text(catModel.name)
                            .frame(minWidth: 60)
                            .padding()
                            .bold()
                            .foregroundColor(pickedCategoryId == catModel.id! ? ColorMaker.buildforegroundTextColor(catColor: catModel.color) : .black)
                            .background(pickedCategoryId == catModel.id! ? catModel.buildColor() : .white)
                            .cornerRadius(10)
                    }
                }
            }
            .scrollOffset($scrollOffset, direction: .horizontal, coordinateSpaceName: coordinateSpaceName)
        }
        .coordinateSpace(name: coordinateSpaceName)
        .overlay(alignment: .center) {
            HStack {
                Image(systemName: "arrowshape.backward.fill")
                    .opacity(scrollOffset <= -20 ? 0.9 : 0)
                Spacer()
                Image(systemName: "arrowshape.right.fill")
                    .opacity(true ? 0.9 : 0)
            }
            .allowsHitTesting(false)
        }
    }
}
