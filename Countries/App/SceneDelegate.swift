//
//  SceneDelegate.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let rootViewController: UIViewController
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            rootViewController = CountriesVC()
        } else {
            rootViewController = LoginVC()
        }
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func logoutForTesting() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        UserDefaults.standard.set(UserDefaults.standard.bool(forKey: "isLoggedIn"), forKey: "isLoggedIn")
    }
    
    
}

