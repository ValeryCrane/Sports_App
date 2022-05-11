//
//  SignInViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol SignInDisplayLogic: AnyObject {
    func displayError(message: String)
    func signed()
}

class SignInViewController: UIViewController {
    var interactor: SignInBusinessLogic!
    var router: SignInRoutingLogic!
    
    private let textStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let signInButton = UIButton()
    private let registrationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray2
        makeKeyboardDismissable()
        configureTextFields()
        configureStackViews()
        configureSignInButton()
        configureRegistrationButton()
        layoutTextFieldsAndTextStackView()
        layoutSignInAndRegistrationButton()
    }
    
    private func configureStackViews() {
        textStackView.backgroundColor = .white
        textStackView.layer.cornerRadius = 4
        textStackView.layer.shadowColor = UIColor.black.cgColor
        textStackView.layer.shadowOffset = .zero
        textStackView.layer.shadowRadius = 8
        textStackView.layer.shadowOpacity = 0.1
        textStackView.axis = .vertical
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 24
    }
    
    private func configureTextFields() {
        emailField.placeholder = "e-mail"
        emailField.textAlignment = .center
        emailField.font = UIFont(name: "Jura-Bold", size: 24)
        
        passwordField.placeholder = "password"
        passwordField.textAlignment = .center
        passwordField.font = UIFont(name: "Jura-Bold", size: 24)
        passwordField.isSecureTextEntry = true
    }
    
    private func configureSignInButton() {
        signInButton.backgroundColor = Colors.red
        signInButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 24)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.layer.cornerRadius = 4
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOffset = .zero
        signInButton.layer.shadowRadius = 8
        signInButton.layer.shadowOpacity = 0.1
        
        signInButton.addTarget(self, action: #selector(signInButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureRegistrationButton() {
        registrationButton.backgroundColor = Colors.gray3
        registrationButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 24)
        registrationButton.setTitleColor(Colors.gray4, for: .normal)
        registrationButton.setTitle("Registration", for: .normal)
        registrationButton.layer.cornerRadius = 4
        registrationButton.layer.shadowColor = UIColor.black.cgColor
        registrationButton.layer.shadowOffset = .zero
        registrationButton.layer.shadowRadius = 8
        registrationButton.layer.shadowOpacity = 0.1
        
        registrationButton.addTarget(self, action: #selector(registrationButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func layoutSignInAndRegistrationButton() {
        buttonStackView.addArrangedSubview(registrationButton)
        buttonStackView.addArrangedSubview(signInButton)
        view.addSubview(buttonStackView)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 64),
            registrationButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 64),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func layoutTextFieldsAndTextStackView() {
        textStackView.addArrangedSubview(emailField)
        textStackView.addArrangedSubview(passwordField)
        view.addSubview(textStackView)
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailField.widthAnchor.constraint(equalTo: textStackView.widthAnchor),
            passwordField.widthAnchor.constraint(equalTo: textStackView.widthAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 64),
            passwordField.heightAnchor.constraint(equalToConstant: 64),
            
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc private func signInButtonPressed(_ sender: UIButton) {
        interactor.signIn(email: emailField.text ?? "", password: passwordField.text ?? "")
    }
    
    @objc private func registrationButtonPressed(_ sender: UIButton) {
        router.routeToRegistrationScene()
    }
}

extension SignInViewController: SignInDisplayLogic {
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func signed() {
        router.routeToApp()
    }
}
