//
//  AuthenticationFirebaseDataSource.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//
/*
import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthenticationFirebaseDataSource{
    
    enum CustomError: Error {
        case noUserFound
    }

    /**
            Returns User loggedIn in current session
     */
    func getCurrentUser() async throws -> User {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw CustomError.noUserFound
        }

        let db = Firestore.firestore()
        let document = try await db.collection("User").document(firebaseUser.uid).getDocument()

       // if let document = document, document.exists {
        let data = document.data()
        let id = firebaseUser.uid
        let name = data?["name"] as? String ?? "User"
        let email = firebaseUser.email ?? ""
        let isAdmin = data?["isAdmin"] as? Bool ?? false
        return User(id: id, name: name, email: email, isAdmin: isAdmin)
        //} else {
          //  throw CustomError.noUserFound
        //}
    }

    
    /**
            Returns User signedIn
     */
    func signIn(email: String, password: String) async throws -> User {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            return try await getCurrentUser()
        } catch {
            throw error
        }
    }

    /**
            Registers user in firebase
     */
    func register(email: String, password: String, name: String, isAdmin: Bool) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let db = Firestore.firestore()
            try await db.collection("users").document(result.user.uid).setData([
                "name": name,
                "email": email,
                "isAdmin": isAdmin
            ])
            
            return try await getCurrentUser()
        } catch {
            throw error
        }
    }
    


    // Método para cerrar sesión
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            throw signOutError
        }
    }

}

*/
