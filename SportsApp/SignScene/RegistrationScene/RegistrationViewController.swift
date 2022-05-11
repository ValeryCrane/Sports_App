//
//  RegistrationViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol RegistrationDisplayLogic: AnyObject {
    func displayError(message: String)
    func signed()
}

class RegistrationViewController: UIViewController {
    var interactor: RegistrationBusinessLogic!
    var router: RegistrationRoutingLogic!
    
    private let stackView = UIStackView()
    private let nameView = TextFieldWithTitle(title: "Name", placeholder: "Ben", keyboardType: .default)
    private let emailView = TextFieldWithTitle(title: "E-mail", placeholder: "example@example.com", keyboardType: .emailAddress)
    private let heightView = TextFieldWithTitle(title: "Height", placeholder: "178", keyboardType: .numberPad)
    private let weightView = TextFieldWithTitle(title: "Weight", placeholder: "84", keyboardType: .numberPad)
    private let passwordView = TextFieldWithTitle(title: "Password", placeholder: "5t@Jd6J<", keyboardType: .default)
    private let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray2
        passwordView.textField.isSecureTextEntry = true
        makeKeyboardDismissable()
        configureSignUpButton()
        layout()
    }
    
    private func configureSignUpButton() {
        signUpButton.backgroundColor = Colors.red
        signUpButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 24)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.layer.cornerRadius = 4
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOffset = .zero
        signUpButton.layer.shadowRadius = 8
        signUpButton.layer.shadowOpacity = 0.1
        signUpButton.titleLabel?.textAlignment = .left
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func layout() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.spacing = 32
        scrollView.addSubview(stackView)
        
        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.distribution = .fillEqually
        innerStackView.spacing = 32
        innerStackView.addArrangedSubview(heightView)
        innerStackView.addArrangedSubview(weightView)
        [nameView, emailView, innerStackView, passwordView, signUpButton].forEach({ stackView.addArrangedSubview($0) })
        [scrollView, nameView, emailView, heightView, weightView,
         passwordView, stackView, innerStackView, signUpButton].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        configureKeyboardInsets(bottomScrollConstraint: scrollViewBottomConstraint)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollViewBottomConstraint,
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    @objc private func signUpButtonPressed(_ sender: UIButton) {
        guard
            let height = Double(heightView.getText()),
            let weight = Double(weightView.getText())
        else {
            displayError(message: "Wrong height or weight parameter!")
            return
        }
        interactor.register(
            name: nameView.getText(),
            email: emailView.getText(),
            password: passwordView.getText(),
            height: height,
            weight: weight
        )
    }
    
}

extension RegistrationViewController: RegistrationDisplayLogic {
    func displayError(message: String) {
        displayErrorAlert(message: message)
    }
    
    func signed() {
        router.routeToApp()
    }
}
