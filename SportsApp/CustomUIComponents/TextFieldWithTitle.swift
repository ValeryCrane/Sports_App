//
//  RegistrationView.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class TextFieldWithTitle: UIView {
    let titleLabel = UILabel()
    let textField = TextFieldWithInsets(leftInset: 16, rightInset: 16)
    
    init(title: String, placeholder: String, keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        configure()
        layout()
    }
    
    public func getText() -> String {
        return textField.text ?? ""
    }
    
    private func configure() {
        titleLabel.font = UIFont(name: "Jura-Bold", size: 24)
        textField.font = UIFont(name: "Jura-Bold", size: 16)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 4
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 8
        textField.layer.shadowOpacity = 0.1
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(textField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
