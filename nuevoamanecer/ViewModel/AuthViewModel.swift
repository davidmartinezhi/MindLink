//
//  AuthViewModel.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 17/05/23.
//
/*
 import Foundation
 
 
 class AuthViewModel: ObservableObject {
 @Published var user: User?
 @Published var errorMessage: String?
 
 private var authDataSource = AuthenticationFirebaseDataSource()
 
 func getCurrentUser() async {
 do {
 DispatchQueue.main.async {
 user = try await authDataSource.getCurrentUser()
 }
 } catch {
 print("Error getting current user: \(error)")
 user = nil
 }
 }
 
 func signIn(email: String, password: String) async {
 do {
 user = try await authDataSource.signIn(email: email, password: password)
 errorMessage = nil  // Borrar cualquier mensaje de error previo al iniciar sesión con éxito
 } catch {
 print("Error signing in: \(error)")
 user = nil
 errorMessage = error.localizedDescription  // Actualizar el mensaje de error
 }
 }
 
 
 func register(email: String, password: String, name: String, isAdmin: Bool) async {
 do {
 user = try await authDataSource.register(email: email, password: password, name: name, isAdmin: isAdmin)
 } catch {
 print("Error registering: \(error)")
 user = nil
 }
 }
 
 func signOut() {
 do {
 try authDataSource.signOut()
 user = nil
 } catch {
 print("Error signing out: \(error)")
 }
 }
 }
 */
