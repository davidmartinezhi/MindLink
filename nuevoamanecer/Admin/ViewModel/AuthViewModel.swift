// Importación de las librerías necesarias para la ejecución del código.
import SwiftUI
import Firebase
import FirebaseFirestore

// Definición de la clase AuthViewModel que hereda de ObservableObject, esto permite la actualización de la vista en respuesta a los cambios de estado en esta clase.

struct AuthActionResult {
    let userId: String? 
    let success: Bool
    
    init(userId: String? = nil, success: Bool){
        self.userId = userId
        self.success = success
    }
}

enum AuthUserProperty {
    case email, password
}

class AuthViewModel: ObservableObject {
    private var auth: Auth = Auth.auth()
    
    func loggedInAuthUserId() -> String? {
        return auth.currentUser?.uid
    }
    
    // Inicia la sesión de un usuario existente.
    func loginAuthUser(email: String, password: String) async -> AuthActionResult {
        do {
            let signedInUser: FirebaseAuth.User = try await self.auth.signIn(withEmail: email, password: password).user
            return AuthActionResult(userId: signedInUser.uid, success: true)
        } catch {
            return AuthActionResult(success: false)
        }
    }
    
    // Revalida al usuario actual, con el correo y contraseña proporcionados.
    func reauthenticateAuthUser(email: String, password: String) async -> AuthActionResult {
        if auth.currentUser == nil {
            return AuthActionResult(success: false)
        }
        
        do {
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
            let reauthenticatedUser: FirebaseAuth.User = try await self.auth.currentUser!.reauthenticate(with: credential).user
            return AuthActionResult(userId: reauthenticatedUser.uid, success: true)
        } catch {
            return AuthActionResult(success: false)
        }
    }
    
    // Crea un nuevo usuario, y si la creación es exitosa, inicia su sesión.
    func createNewAuthAccount(email: String, password: String) async -> AuthActionResult {
        do {
            let createdUser: FirebaseAuth.User = try await self.auth.createUser(withEmail: email, password: password).user
            return AuthActionResult(userId: createdUser.uid, success: true)
        } catch {
            return AuthActionResult(success: false)
        }
    }
    
    // Modifica una de las siguientes dos propiedades del usuario actual: email o contraseña.
    func updateCurrentAuthUser(value: String, userProperty: AuthUserProperty) async -> AuthActionResult {
        switch userProperty {
        case .email:
            return await self.updateEmail(email: value)
        case .password:
            return await self.updatePassword(password: value)
        }
    }

    // Modifica el correo del usuario actual.
    private func updateEmail(email: String) async -> AuthActionResult {
        if self.auth.currentUser == nil {
            return AuthActionResult(success: false)
        }
        
        do {
            try await self.auth.currentUser!.updateEmail(to: email)
            return AuthActionResult(success: true)
        } catch {
            return AuthActionResult(success: false)
        }
    }
    
    // Modifica la contraseña del usuario actual.
    private func updatePassword(password: String) async -> AuthActionResult {
        if self.auth.currentUser == nil {
            return AuthActionResult(success: false)
        }
        
        do {
            try await self.auth.currentUser!.updatePassword(to: password)
            return AuthActionResult(success: true)
        } catch {
            return AuthActionResult(success: false)
        }
    }
    
    // Termina la sesión del usuario actual.
    func logout() -> AuthActionResult {
        do {
            try Auth.auth().signOut()
            return AuthActionResult(success: true)
        } catch  {
            return AuthActionResult(success: false)
        }
    }
}
