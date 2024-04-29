//
//  LoginViewModel.swift
//  Countries
//
//  Created by Irinka Datoshvili on 26.04.24.
//

import Foundation

class LoginViewModel {
    
    // MARK: - Properties
    
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - Public methods
    
    // MARK: - Login Logic

    func loginAndValidate(username: String, password: String, repeatPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let validationMessage = validateLogin(username: username, password: password, repeatPassword: repeatPassword) else {
            login(username: username, password: password) { success in
                completion(success, nil)
            }
            return
        }
        completion(false, validationMessage)
    }
    
    func saveImage(_ imageData: Data) {
        saveImageToDocumentsDirectory(imageData: imageData)
    }
    
    // MARK: - Private methods
    
    private func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        saveToKeychain(username: username, password: password)
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        completion(true)
    }
    
    private func validateLogin(username: String, password: String, repeatPassword: String) -> String? {
        if username.isEmpty || password.isEmpty || repeatPassword.isEmpty {
            return "Please fill in all required fields."
        }
        if password != repeatPassword {
            return "Passwords do not match."
        }
        return nil
    }
    
    private func isFirstTimeLogin() -> Bool {
        return !userDefaults.bool(forKey: "hasLoggedInBefore")
    }
    
    private func saveToKeychain(username: String, password: String) {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            let usernameQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "username",
                kSecAttrService as String: bundleIdentifier,
                kSecValueData as String: username.data(using: .utf8)!
            ]
            let passwordQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "password",
                kSecAttrService as String: bundleIdentifier,
                kSecValueData as String: password.data(using: .utf8)!
            ]
            
            SecItemDelete(usernameQuery as CFDictionary)
            SecItemDelete(passwordQuery as CFDictionary)
            
            SecItemAdd(usernameQuery as CFDictionary, nil)
            SecItemAdd(passwordQuery as CFDictionary, nil)
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        } else {
            print("Bundle Identifier is nil")
        }
    }
    
    // MARK: - Image Handling
    
    private func saveImageToDocumentsDirectory(imageData: Data) {
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsURL.appendingPathComponent("selectedPhoto.jpg")
        
        do {
            try imageData.write(to: imageURL)
            print("Image saved to: \(imageURL)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
}
