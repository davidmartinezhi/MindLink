// Importación de las librerías necesarias para la ejecución del código.
import SwiftUI
import Firebase
import FirebaseFirestore

// Definición de la clase AuthViewModel que hereda de ObservableObject, esto permite la actualización de la vista en respuesta a los cambios de estado en esta clase.
class AuthViewModel: ObservableObject {

    // Definición de dos variables publicadas que actualizarán la vista cuando cambien.
    @Published var errorMessage : String? = nil // Un mensaje de error que se mostrará en la interfaz de usuario.
    @Published var errorLogin : Bool = false   // un mensaje de error se mostrarra cundo no se puede verificar las credenciales
    @Published var user: User? // Un objeto de usuario opcional, que contendrá los datos del usuario autenticado.
    @Published var validar : Bool = false
    
    // El inicializador llama a la función fetchCurrentUser cuando se crea una instancia de AuthViewModel.
    init(){
        fetchCurrentUser()
    }

    // Definición de la función fetchCurrentUser que se encargará de recuperar los datos del usuario autenticado desde Firestore.
    func fetchCurrentUser() {

        // Comprueba si existe un id para el usuario actualmente autenticado. Si no existe, se establece un mensaje de error y se retorna de la función.
        guard let id = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No se encontró el id "
            return
        }

        // Intenta obtener el documento del usuario desde Firestore utilizando el id. Maneja cualquier error que pueda ocurrir durante este proceso.
        Firestore.firestore().collection("User").document(id).getDocument { snapshop, error in
            // Si hay un error, actualiza el mensaje de error y registra el error, luego retorna de la función.
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user: \(error)")
                return
            }

            // Si no hay errores, establece el mensaje de error como "123" (parece que este es un valor temporal y probablemente debería ser reemplazado con un mensaje más descriptivo o eliminado por completo).

            // Verifica que los datos del snapshot existen. Si no, establece un mensaje de error y retorna de la función.
            guard let data = snapshop?.data() else {
                self.errorMessage = "No data found"
                return
            }

            // Recupera los datos del usuario del diccionario de datos. Si no encuentra un valor para una clave dada, se utiliza un valor predeterminado.
            let id = data["id"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let isAdmin = data["isAdmin"] as? Bool ?? false
            let image = data["image"] as? String ?? ""

            // Crea un nuevo objeto User con los datos recuperados y lo asigna a la variable de usuario publicada. Esto desencadenará una actualización en cualquier vista que esté observando esta variable.
            self.user = User(id: id, name: name, email: email, isAdmin: isAdmin, image: image)
        }
    }
    
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login", err)
                self.errorMessage = "Failed to login user: \(err)"
                self.errorLogin = true
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            //user = result?.user.id
            self.fetchCurrentUser()
        }
    }
    
    
    func createNewAccount(email: String, password: String, name: String, isAdmin: Bool, adminEmail: String, adminPassword: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create account", err)
                self.errorMessage = "Failed to create user: \(err)"
                return
            } else {
                guard let uid = result?.user.uid else { return }
                print("Successfully created user: \(uid.self)")
                self.storeUserInformation(id: uid, name: name, email: email, isAdmin: isAdmin, image: "")
                try! Auth.auth().signOut()
                
                self.loginUser(email: adminEmail, password: adminPassword)
            }
        }
    }
    
    //funcion que verifique que la contraseña ingresada contenga los caracteres necesarios para tener una contraseña fuerte
    func isWeak (_ password: String)-> Bool{
        let passwordLenght = password.count
        var containsSynbol = false
        var containsNumber = false
        var containsUpercase = false
        for character in password {
            if ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character)){
                containsUpercase = true
            }
            if ("1234567890".contains(character)){
                containsNumber = true
            }
            if ("!?#$%&/()=;:_-.,°".contains(character)){
                containsSynbol = true
            }
        }
        if (passwordLenght > 8 && containsSynbol  && containsUpercase && containsNumber){
            return false
        } else {
            return true
        }
    }
    
    private func storeUserInformation(id: String, name: String, email: String, isAdmin: Bool, image: String) {
        let userData = ["name": name, "email": email, "isAdmin": isAdmin, "id": id, "image": image] as [String : Any]
        Firestore.firestore().collection("User").document(id).setData(userData) { err in
            if let err = err {
                print(err)
                self.errorMessage = "\(err)"
                return
            }
            print("Success")
            self.fetchCurrentUser()
        }
    }
    
    func updateUser(name: String?, isAdmin: Bool?, image: String?, email: String?) {
        // Verificar si hay un usuario autenticado actualmente
        guard let id = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No se encontró el id del usuario autenticado"
            return
        }

        // Crear un objeto con la información actualizada
        var updateData: [String: Any] = [:]

        // Verificar si cada parámetro no es nil antes de agregarlo al objeto de actualización
        if let name = name { updateData["name"] = name }
        if let isAdmin = isAdmin { updateData["isAdmin"] = isAdmin }
        if let image = image { updateData["image"] = image }
        if let email = email { updateData["email"] = email }

        // Llamar a la función de actualización de Firestore para el usuario con la identificación actual
        Firestore.firestore().collection("User").document(id).updateData(updateData) { err in
            if let err = err {
                print(err)
                self.errorMessage = "\(err)"
                return
            }
            print("Se ha actualizado la información del usuario")
            self.fetchCurrentUser() // Recarga la información del usuario
        }
    }
    
    func updateUserImage(name: String?, image: String?) {
        // Verificar si hay un usuario autenticado actualmente
        guard let id = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No se encontró el id del usuario autenticado"
            return
        }

        // Crear un objeto con la información actualizada
        var updateData: [String: Any] = [:]

        // Verificar si cada parámetro no es nil antes de agregarlo al objeto de actualización
        if let name = name { updateData["name"] = name }
        //if let isAdmin = isAdmin { updateData["isAdmin"] = isAdmin }
        if let image = image { updateData["image"] = image }

        // Llamar a la función de actualización de Firestore para el usuario con la identificación actual
        Firestore.firestore().collection("User").document(id).updateData(updateData) { err in
            if let err = err {
                print(err)
                self.errorMessage = "\(err)"
                return
            }
            print("Se ha actualizado la información del usuario")
            self.fetchCurrentUser() // Recarga la información del usuario
        }
    }
    
    // Actualizar datos de autentificacion
    func updateAuthEmail (email: String) {
        Auth.auth().currentUser?.updateEmail(to: email) {(error) in
            if let error = error as NSError? {
                print(error)
            }else {
                print("se actualizo el email")
            }
        }
    }
    func updateAuthPassword (password: String) {
        Auth.auth().currentUser?.updatePassword(to: password ) { (error) in
            if let error = error as NSError? {
                print(error)
            }else {
                print("se actualizo la contraseña")
            }
        }
    }
    
    func autenticar (email: String, password: String) async {
        do{
            let authAdmin = try await Auth.auth().signIn(withEmail: email, password: password)
            print("BIEN")
            self.validar = true
            print(self.validar)
            return
        }catch {
            print("Error")
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            // manejar acciones post-cierre de sesión aquí
            // como redirigir al usuario a la vista de inicio de sesión
            user = nil
            print("CERRO SECION")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
