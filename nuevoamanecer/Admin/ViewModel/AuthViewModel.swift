// Importación de las librerías necesarias para la ejecución del código.
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

// Definición de la clase AuthViewModel que hereda de ObservableObject, esto permite la actualización de la vista en respuesta a los cambios de estado en esta clase.

struct AuthActionResult {
    let userId: String? 
    let success: Bool
    let errorMessage: String?
    
    init(userId: String? = nil, success: Bool, errorMessage: String? = nil){
        self.userId = userId
        self.success = success
        self.errorMessage = errorMessage
    }
}

enum AuthUserProperty {
    case email, password
}

class AuthViewModel: ObservableObject {
    private var auth: Auth = Auth.auth()
    private var inActiveSession: Bool {
        auth.currentUser != nil
    }
    
    func loggedInAuthUserId() -> String? {
        return auth.currentUser?.uid
    }
    
    // Inicia la sesión de un usuario existente.
    func loginAuthUser(email: String, password: String) async -> AuthActionResult {
        do {
            let signedInUser: FirebaseAuth.User = try await self.auth.signIn(withEmail: email, password: password).user
            return AuthActionResult(userId: signedInUser.uid, success: true)
        } catch let error as NSError  {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    // Revalida al usuario actual, con el correo y contraseña proporcionados.
    func reauthenticateAuthUser(email: String, password: String) async -> AuthActionResult {
        if !inActiveSession {
            return AuthActionResult(success: false, errorMessage: "No existe una sesión activa")
        }
        
        do {
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
            let reauthenticatedUser: FirebaseAuth.User = try await self.auth.currentUser!.reauthenticate(with: credential).user
            return AuthActionResult(userId: reauthenticatedUser.uid, success: true)
        } catch let error as NSError {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    // Crea un nuevo usuario.
    func createNewAuthAccount(email: String, password: String, currUserPassword: String) async -> AuthActionResult {
        if !inActiveSession {
            return AuthActionResult(success: false, errorMessage: "No existe una sesión activa")
        }
        
        let currUserEmail: String = auth.currentUser!.email!
        
        let reauthenticationResult: AuthActionResult = await self.reauthenticateAuthUser(email: currUserEmail, password: currUserPassword)
        
        if !reauthenticationResult.success {
            return reauthenticationResult
        }
        
        do {
            let createdUser: FirebaseAuth.User = try await self.auth.createUser(withEmail: email, password: password).user
            
            _ = await self.loginAuthUser(email: currUserEmail, password: currUserPassword)
            
            return AuthActionResult(userId: createdUser.uid, success: true)
        } catch let error as NSError {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    // Modifica una de las siguientes dos propiedades del usuario actual: email o contraseña.
    func updateCurrentAuthUser(value: String, userProperty: AuthUserProperty, currUserPassword: String) async -> AuthActionResult {
        if !inActiveSession {
            return AuthActionResult(success: false, errorMessage: "No existe una sesión activa")
        }
        
        let reauthenticationResult: AuthActionResult = await self.reauthenticateAuthUser(email: auth.currentUser!.email!, password: currUserPassword)
        
        if !reauthenticationResult.success {
            return reauthenticationResult
        }
        
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
        } catch let error as NSError {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    // Modifica la contraseña del usuario actual.
    private func updatePassword(password: String) async -> AuthActionResult {
        if self.auth.currentUser == nil {
            return AuthActionResult(success: false, errorMessage: "No hay una sesión activa")
        }
        
        do {
            try await self.auth.currentUser!.updatePassword(to: password)
            return AuthActionResult(success: true)
        } catch let error as NSError {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    // Termina la sesión del usuario actual.
    func logout() -> AuthActionResult {
        do {
            try self.auth.signOut()
            return AuthActionResult(success: true)
        } catch let error as NSError {
            return AuthActionResult(success: false, errorMessage: handleAuthError(error))
        }
    }
    
    private func handleAuthError(_ error: NSError) -> String {
        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
                return "Usuario no encontrado"
        case AuthErrorCode.wrongPassword.rawValue:
                return "Contraseña incorrecta"
        case AuthErrorCode.invalidEmail.rawValue:
                return "Correo electrónico inválido"
        case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "El correo electrónico ya está en uso"
        case AuthErrorCode.userDisabled.rawValue:
                return "La cuenta de usuario ha sido deshabilitada"
        case AuthErrorCode.invalidCredential.rawValue:
                return "Credenciales de autenticación inválidas"
        case AuthErrorCode.operationNotAllowed.rawValue:
                return "Operación no permitida"
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                return "La cuenta ya existe con diferentes credenciales"
        case AuthErrorCode.networkError.rawValue:
                return "Error de red. Verifica tu conexión"
        case AuthErrorCode.tooManyRequests.rawValue:
                return "Demasiados intentos. Intenta de nuevo más tarde"
        case AuthErrorCode.weakPassword.rawValue:
            return "Contraseña débil"
        default:
            return "Error desconocido: \(error.localizedDescription)"
        }
    }
}
