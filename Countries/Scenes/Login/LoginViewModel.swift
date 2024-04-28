//
//  LoginViewModel.swift
//  Countries
//
//  Created by Irinka Datoshvili on 26.04.24.
//

import Foundation
import UIKit

class LoginViewModel {
    func isFirstTimeLogin() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLoggedInBefore")
    }
    
    func saveToKeychain(username: String, password: String) {
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
    func saveImageToDocumentsDirectory(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsURL.appendingPathComponent("selectedPhoto.jpg")
        
        do {
            try data.write(to: imageURL)
            print("Image saved to: \(imageURL)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
}
