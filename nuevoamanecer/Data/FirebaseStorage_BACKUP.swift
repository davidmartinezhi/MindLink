//
//  FirebaseStorage.swift
//  nuevoamanecer
//
//  Created by Jose Arguelles Rios on 28/05/23.
//

/*
import Foundation
import FirebaseStorage
import UIKit

class FirebaseAlmacenamiento {
    func uploadImage(image:UIImage, name:String, completion: @escaping (URL?) -> Void) async {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let storage = Storage.storage()
                do {
                    let storedImage = try await storage.reference().child(name + ".jpg").putDataAsync(imageData, metadata:nil)
                    
                    let storageRef = Storage.storage().reference(withPath: name + ".jpg")
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            print((error?.localizedDescription)!)
                            completion (nil)
                        } else {
                            completion (url)
                        }
                    }
                }
                catch {
                    print("No se pudo subir la imagen")
                }
            } else {
                print("No se pudo subir la imagen")
            }
        }
    func deleteFile(name: String) {
        //Crear referencia
        let referencia = Storage.storage().reference().child(name + ".jpg")
        //Borrar archivo
        referencia.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
              print(error.localizedDescription)
          } else {
            // File deleted successfully
              print("Archivo borrado con exito")
          }
        }
    }
}
*/
