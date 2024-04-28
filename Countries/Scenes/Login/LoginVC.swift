//
//  LoginVC.swift
//  Countries
//
//  Created by Irinka Datoshvili on 26.04.24.
//

import UIKit

// MARK: - Login Controller

class LoginVC: UIViewController {
    private var loginView = LoginView()
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func loadView() {
        view = loginView
    }
    private func setupActions() {
        loginView.photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)
        loginView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginView.imagePicker.delegate = self
        
    }
    private func showWelcomeAlert() {
        let alert = UIAlertController(title: "Welcome", message: "Welcome to our app!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCountriesVC() {
        let countriesVC = CountriesVC()
        navigationController?.pushViewController(countriesVC, animated: true)
    }
    @objc func didTapPhotoButton() {
        present(loginView.imagePicker, animated: true, completion: nil)
    }
    
    @objc func didTapLoginButton() {
            guard let username = loginView.usernameTextField.text,
                  let password = loginView.passwordTextField.text,
                  let repeatPassword = loginView.repeatPasswordTextField.text else {
                showAlert(message: "Please fill in all required fields.")
                return
            }
            
            viewModel.loginAndValidate(username: username, password: password, repeatPassword: repeatPassword) { success, validationMessage in
                if success {
                    self.navigateToCountriesVC()
                    self.showWelcomeAlert()
                } else if let message = validationMessage {
                    self.showAlert(message: message)
                }
            }
        }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            loginView.photoButton.setImage(pickedImage, for: .normal)
            if let imageData = pickedImage.jpegData(compressionQuality: 1) {
                viewModel.saveImage(imageData)
            } else {
                print("Error converting image to data")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

