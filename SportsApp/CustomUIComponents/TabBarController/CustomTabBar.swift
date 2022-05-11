//
//  CustomTabBar.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 17.04.2022.
//

import Foundation
import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func selected(index: Int)
}

class CustomTabBar: UIView {
    var buttons: [UIButton] = []
    weak var delegate: CustomTabBarDelegate?
    
    
    // MARK: - Initialisators
    init() {
        super.init(frame: .zero)
        self.backgroundColor = Colors.gray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods.
    // Configures TabBar based on ViewControllers and selected Index.
    func configure(with viewControllers: [UIViewController]?, selectedIndex: Int) {
        guard let viewControllers = viewControllers else { return }
        
        // Creating buttons for TabBar
        let images = viewControllers.compactMap({ $0.tabBarItem.image?.withRenderingMode(.alwaysTemplate) })
        let buttons = images.map { (image: UIImage) -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.tintColor = Colors.gray3
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            return button
        }
        
        self.buttons = buttons
        selectButton(buttons[selectedIndex])
        layoutButtons()
    }
    
    
    // MARK: - Private methods.
    // Makes button selected.
    private func selectButton(_ buttonToSelect: UIButton) {
        for button in buttons {
            if button == buttonToSelect {
                button.tintColor = Colors.red
            } else {
                button.tintColor = Colors.gray3
            }
        }
    }
    
    private func findIndexOf(button: UIButton) -> Int? {
        for i in 0 ..< buttons.count {
            if buttons[i] == button {
                return i
            }
        }
        return nil
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        selectButton(sender)
        if let indexOfButton = findIndexOf(button: sender) {
            delegate?.selected(index: indexOfButton)
        }
    }
    
    
    // MARK: - Layout functions.
    // Layouts buttons in tabBar.
    private func layoutButtons() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        if buttons.count > 1 {
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        } else {
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
}
