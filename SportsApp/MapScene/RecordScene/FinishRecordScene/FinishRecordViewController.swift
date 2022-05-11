//
//  FinishRecordViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol FinishRecordDisplayLogic: AnyObject {
    func displayError(message: String)
    func restartRecord()
}

class FinishRecordViewController: UIViewController {
    var interactor: FinishRecordBusinessLogic!
    var router: FinishRecordRoutingLogic!
    
    private let nameField = TextFieldWithTitle(title: "Name", placeholder: "Morning ride", keyboardType: .default)
    private let descriptionField = TextViewWithTitle(title: "Description", placeholder: "Weather was amazing!")
    private let dismissRideButton = UIButton()
    private let saveRideButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray2
        makeKeyboardDismissable()
        configureDismissRideButton()
        configureSaveRideButton()
        layout()
    }
    
    private func configureDismissRideButton() {
        dismissRideButton.backgroundColor = Colors.gray2
        dismissRideButton.setTitle("Dismiss ride", for: .normal)
        dismissRideButton.setTitleColor(Colors.red.withAlphaComponent(0.5), for: .normal)
        dismissRideButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 24)
        dismissRideButton.addCornerRadiusAndShadow()
        dismissRideButton.addTarget(self, action: #selector(dismissRideButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureSaveRideButton() {
        saveRideButton.backgroundColor = Colors.red
        saveRideButton.setTitle("Save ride", for: .normal)
        saveRideButton.setTitleColor(.white, for: .normal)
        saveRideButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 24)
        saveRideButton.addCornerRadiusAndShadow()
        saveRideButton.addTarget(self, action: #selector(saveRideButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func layout() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.clipsToBounds = false
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(descriptionField)
        stackView.addArrangedSubview(dismissRideButton)
        stackView.addArrangedSubview(saveRideButton)
        
        [stackView, scrollView, nameField, descriptionField].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            
            dismissRideButton.heightAnchor.constraint(equalToConstant: 64),
            saveRideButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    @objc private func dismissRideButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "This ride will be completely lost!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete ride", style: .destructive) { [weak self] _ in
            self?.router.restartRecord()
        })
        present(alert, animated: true)
    }
    
    @objc private func saveRideButtonPressed(_ sender: UIButton) {
        interactor.saveRide(name: nameField.getText(), description: descriptionField.getText())
    }
}

extension FinishRecordViewController: FinishRecordDisplayLogic {
    func displayError(message: String) {
        displayErrorAlert(message: message)
    }
    
    func restartRecord() {
        router.restartRecord()
    }
}
