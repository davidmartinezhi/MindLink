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
