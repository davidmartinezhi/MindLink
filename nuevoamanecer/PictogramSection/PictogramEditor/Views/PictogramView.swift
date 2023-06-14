//
//  PictogramView.swift
//  Comunicador
//
//  Created by emilio on 23/05/23.
//

import SwiftUI
import Kingfisher

// Definición de la vista del Pictograma
struct PictogramView: View {
    
    // Variables de entrada para configurar la vista
    var pictoModel: PictogramModel    // Modelo del pictograma
    var catModel: CategoryModel        // Modelo de la categoría del pictograma
    var displayName: Bool              // Si se debe mostrar el nombre
    var displayCatColor: Bool          // Si se debe mostrar el color de la categoría
    
    var overlayImage: Image? = nil             // Imagen a superponer
    var overlayImageWidth: CGFloat = 0.2       // Ancho de la imagen a superponer
    var overlayImageColor: Color = .black      // Color de la imagen a superponer
    var overlyImageOpacity: Double = 1         // Opacidad de la imagen a superponer
    
    var temporaryUIImage: UIImage? = nil       // Imagen temporal a utilizar si está disponible

    // Definición del cuerpo de la vista
    var body: some View {
        GeometryReader { geo in
            let w: CGFloat = geo.size.width    // Ancho del marco de la vista
            let h: CGFloat = geo.size.height   // Alto del marco de la vista
            
            // ZStack permite apilar vistas una encima de la otra
            ZStack() {
                // El color de fondo es el color de la categoría
                catModel.buildColor()
                
                // VStack apila las vistas verticalmente
                VStack {
                    // Si se debe mostrar el nombre, se muestra el nombre del pictograma
                    if displayName {
                        Text(pictoModel.name.isEmpty ? "..." : pictoModel.name)
                            .font(.system(size: w * 0.1, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    // Si existe una imagen temporal, se usa, de lo contrario se descarga la imagen del pictograma
                    if let tempUIImage = temporaryUIImage {
                        Image(uiImage: tempUIImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .foregroundColor(.gray)
                    } else {
                        KFImage(URL(string: pictoModel.imageUrl))
                            .placeholder{
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geo.size.width * 0.6)
                                    .foregroundColor(.gray)
                                    .opacity(0.2)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                // Padding y tamaño de la vista
                .padding(.horizontal, w * 0.05)
                .padding(.vertical, h * 0.05)
                .frame(width: w * (displayCatColor ? 0.9 : 1), height: h * (displayCatColor ? 0.9 : 1))
                .background(.white)   // Fondo de la vista
            }
            .border(.gray)
            .overlay(alignment: .topTrailing) {
                if overlayImage != nil {
                    overlayImage!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(overlayImageColor)
                        .opacity(overlyImageOpacity)
                        .frame(width: geo.size.width * overlayImageWidth)
                        .padding(10)
                }
            }
        }
    }
}


struct PictogramView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World!")
        }
    }
}
