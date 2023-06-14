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
    @State var pickedCatModel: CategoryModel?
    var itemWidth: CGFloat
    var itemHeight: CGFloat
    var textSize: Double = 15
    
    @State private var listWindowHeight: CGFloat = 0
    
    init(categoryModels: [CategoryModel], pickedCategoryId: Binding<String>, pickedCatModel: CategoryModel?, itemWidth: CGFloat = 150, itemHeight: CGFloat = 60){
        self.categoryModels = categoryModels
        _pickedCategoryId = pickedCategoryId
        _pickedCatModel = State(initialValue: pickedCatModel)
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
    }
    
    var body: some View {
        let listWindowHeightExpanded: CGFloat = itemHeight * 3.9
        let bgColor: Color = Color(red: 0.9, green: 0.9, blue: 0.9)
        
        Button {
            withAnimation {
                listWindowHeight = listWindowHeight == 0 ? listWindowHeightExpanded : 0
            }
        } label: {
            HStack(spacing: 15){
                Rectangle()
                    .frame(width: 10, height: itemHeight)
                    .foregroundColor(pickedCatModel == nil ? bgColor : pickedCatModel!.buildColor())
                Text(pickedCatModel == nil ? "Categoría" : pickedCatModel!.name)
                    .font(.system(size: textSize, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: listWindowHeight == 0 ? "chevron.up" : "chevron.down")
            }
            .padding(.trailing, 10)
            .frame(width: itemWidth, height: itemHeight)
            .background(bgColor)
            .cornerRadius(5)
        }
        .overlay(alignment: .top){
            if listWindowHeight != 0 {
                ScrollView(.vertical){
                    VStack(spacing: 0){
                        ForEach(categoryModels){ catModel in
                            Button {
                                pickedCategoryId = catModel.id!
                                pickedCatModel = catModel
                                withAnimation {
                                    listWindowHeight = listWindowHeight == 0 ? listWindowHeightExpanded : 0
                                }
                            } label: {
                                HStack {
                                    Text(catModel.name)
                                        .font(.system(size: textSize, weight: .bold))
                                        .foregroundColor(ColorMaker.buildforegroundTextColor(catColor: catModel.color))
                                    Spacer()
                                    if catModel.id! == pickedCategoryId {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(ColorMaker.buildforegroundTextColor(catColor: catModel.color))
                                    }
                                }
                                .padding()
                                .frame(width: itemWidth, height: itemHeight)
                                .background(catModel.buildColor())
                            }
                        }
                    }
                }
                .frame(height: listWindowHeight)
                .background(bgColor)
                .cornerRadius(5)
                .offset(y: (listWindowHeightExpanded * -1) - 10)
                .animation(.easeIn, value: listWindowHeight)
            }
        }
    }
}
