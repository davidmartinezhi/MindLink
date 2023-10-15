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
    
    var clickAction: (()->Void)? = nil
    
    @State var isBeingTapped: Bool = false
    
    // Definición del cuerpo de la vista
    var pictogramBody: some View {
        GeometryReader { geo in
            let w: CGFloat = geo.size.width    // Ancho del marco de la vista
            let h: CGFloat = geo.size.height   // Alto del marco de la vista
                
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
            .frame(width: w, height: h)
            .background(.white)   // Fondo de la vista
            .border(displayCatColor || isBeingTapped ? catModel.buildColor() : .gray, width: displayCatColor || isBeingTapped ? 7 : 1)
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

    // Aplicación condicional de un gesto táctil al cuerpo del pictograma.
    var body: some View {
        if clickAction != nil {
            pictogramBody
                .gesture(
                    TapGesture(count: 1)
                        .onEnded {
                            isBeingTapped = true
                            clickAction!()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                                       isBeingTapped = false
                            }
                        }
                )
        } else {
            pictogramBody
        }
    }
}
