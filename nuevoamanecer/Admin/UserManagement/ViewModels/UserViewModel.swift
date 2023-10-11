//
//  UserViewModel.swift
//  nuevoamanecer
//
//  Created by emilio on 22/09/23.
//

import Foundation
import Firebase
import FirebaseFirestore

enum UserProperty: String {
    case name = "name"
    case email = "email"
    case image = "image"
}

class UserViewModel {
    private var userCollection: CollectionReference = Firestore.firestore().collection("User")
    
    func getUser(userId: String, completition: @escaping (Error?, User?)->Void) -> Void {
        self.userCollection.document(userId).getDocument(as: User.self) { result in
            do {
                completition(nil, try result.get())
            } catch let error {
                completition(error, nil)
            }
        }
    }
    
    func getAllUsers(completition: @escaping (Error?, [User]?)->Void) -> Void {
        userCollection.getDocuments { querySnapshot, error in
            if error != nil {
                completition(error, nil)
            } else {
                var users: [User] = []
                
                for document in querySnapshot!.documents {
                    do {
                        users.append(try document.data(as: User.self))
                    } catch let error {
                        completition(error, nil)
                    }
                }
                completition(nil, users)
            }
        }
    }
    
    func addUser(user: User, completition: @escaping (Error?, String?)->Void) -> Void {
        var docRef: DocumentReference? = nil
        
        do {
            docRef = try userCollection.addDocument(from: user) { error in
                if error != nil {
                    completition(error, nil)
                } else {
                    completition(nil, docRef?.documentID)
                }
            }
        } catch let error {
            completition(error, nil)
        }
    }
    
    func addUserWithCustomId(user: User, userId: String, completition: @escaping (Error?)->Void) -> Void {
        userCollection.document(userId).setData(user.toDict()) {error in
            if error != nil {
                completition(error)
            } else {
                completition(nil)
            }
        }
    }
    
    func removeUser(userId: String, completittion: @escaping (Error?)->Void) -> Void {
        userCollection.document(userId).delete { error in
            if error != nil {
                completittion(error)
            } else {
                completittion(nil)
            }
        }
    }
    
    func editUser(userId: String, newUserValue: User, completition: @escaping (Error?)->Void) -> Void {
        do {
            try userCollection.document(userId).setData(from: newUserValue) { error in
                if error != nil {
                    completition(error)
                } else {
                    completition(nil)
                }
            }
        } catch let error {
            completition(error)
        }
    }
    
    func editUserProperty(userId: String, value: String, userProperty: UserProperty, completition: @escaping (Error?)->Void) -> Void {
        userCollection.document(userId).updateData([userProperty.rawValue: value]) { error in
            if error != nil {
                completition(error)
            } else {
                completition(nil)
            }
        }
    }
    
    func editUserAdminState(userId: String, isAdmin: Bool, completition: @escaping (Error?)->Void) -> Void {
        userCollection.document(userId).updateData(["isAdmin": isAdmin]) { error in
            if error != nil {
                completition(error)
            } else {
                completition(nil)
            }
        }
    }
}
