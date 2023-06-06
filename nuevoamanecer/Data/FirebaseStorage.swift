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
    func uploadImage(image:UIImage, name:String) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let storage = Storage.storage()
            storage.reference().child(name + ".jpg").putData(imageData, metadata: nil) {
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
    
    func loadImageFromFirebase(name:String) {
        let storageRef = Storage.storage().reference(withPath: name)
        
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            //self.imageURL = url!
        }
    }
}
