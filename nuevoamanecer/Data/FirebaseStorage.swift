//
//  FirebaseStorage.swift
//  nuevoamanecer
//
//  Created by Jose Arguelles Rios on 28/05/23.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseAlmacenamiento {
    func uploadImage(image:UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let storage = Storage.storage()
            //Donde dice "temp" es el nombre con el que se guardara la imagen en Firestore
            storage.reference().child("fhfh.jpg").putData(imageData, metadata: nil) {
                (data, err) in
                if let err = err {
                    print("Error al subir imagen - \(err.localizedDescription)")
                } else {
                    print("La imagen se subio correctamente")
                }
            }
        } else {
            print("No se pudo subir la imagen")
        }
    }
}
