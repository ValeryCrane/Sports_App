//
//  TextViewWithTitle.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class TextViewWithTitle: UIView {
    let titleLabel = UILabel()
    let textView = UITextView()
    
    let placeholderColor = UIColor.lightGray
    let placeholderText: String
    
    init(title: String, placeholder: String) {
        placeholderText = placeholder
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        layout()
    }
    
    public func getText() -> String {
        return textView.text ?? ""
    }
    
    private func configure() {
        titleLabel.font = UIFont(name: "Jura-Bold", size: 24)
        textView.font = UIFont(name: "Jura-Bold", size: 16)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = placeholderText
        textView.textColor = placeholderColor
        textView.delegate = self
        textView.addCornerRadiusAndShadow()
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(textView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 128)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextViewWithTitle: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor && textView.isFirstResponder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil || textView.text == "" {
            textView.textColor = placeholderColor
            textView.text = placeholderText
        }
    }
}
