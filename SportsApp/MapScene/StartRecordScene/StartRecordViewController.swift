//
//  StartRecordViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 16.04.2022.
//

import Foundation
import UIKit

protocol StartRecordDisplayLogic: AnyObject {
    func displaySportKind(_ sportKind: SportKind)
}

class StartRecordViewController: TouchTransparentViewController {
    var router: StartRecordRoutingLogic!
    
    private var sportKind: SportKind = .running {
        didSet {
            typeOfSportImageView.image = sportKind.getImage()
            typeOfSportLabel.text = sportKind.getName()
        }
    }
    
    private let goButton = UIButton(type: .system)
    private var goButtonBottomConstraint: NSLayoutConstraint?
    
    private let typeOfSportButton = UIButton(type: .system)
    private let typeOfSportImageView = UIImageView()
    private let typeOfSportLabel = UILabel()
    private var typeOfSportButtonBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureGoButton()
        layoutGoButton()
        configureTypeOfSportButton()
        layoutTypeOfSportButton()
        
        sportKind = .running
    }
    
    @objc private func goButtonPressed(_ sender: UIButton) {
        goButtonBottomConstraint?.constant = 104
        typeOfSportButtonBottomConstraint?.constant = 104
        UIView.animate(
            withDuration: 0.2, delay: 0, options: .curveLinear,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                if let sportKind = self?.sportKind {
                    self?.router.routeToRecordScene(sportKind: sportKind)
                }
            }
        )
    }
    
    @objc private func typeOfSportButtonPressed(_ sender: UIButton) {
        router.routeToSportKindScene()
    }
    
    private func configureGoButton() {
        goButton.backgroundColor = Colors.red
        goButton.layer.cornerRadius = 4
        goButton.layer.shadowColor = UIColor.black.cgColor
        goButton.layer.shadowOffset = .zero
        goButton.layer.shadowRadius = 8
        goButton.layer.shadowOpacity = 0.1
        
        goButton.setTitle("GO", for: .normal)
        goButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 32)
        goButton.setTitleColor(Colors.gray1, for: .normal)
        
        goButton.addTarget(self, action: #selector(goButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureTypeOfSportButton() {
        typeOfSportButton.backgroundColor = Colors.gray1
        typeOfSportButton.layer.cornerRadius = 4
        typeOfSportButton.layer.shadowColor = UIColor.black.cgColor
        typeOfSportButton.layer.shadowOffset = .zero
        typeOfSportButton.layer.shadowRadius = 8
        typeOfSportButton.layer.shadowOpacity = 0.1
        
        typeOfSportLabel.font = UIFont(name: "Jura-Bold", size: 24)
        
        typeOfSportImageView.isUserInteractionEnabled = false
        typeOfSportLabel.isUserInteractionEnabled = false
        
        typeOfSportButton.addTarget(self, action: #selector(typeOfSportButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func layoutGoButton() {
        view.addSubview(goButton)
        goButton.translatesAutoresizingMaskIntoConstraints = false
        let goButtonBottomConstraint = goButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        NSLayoutConstraint.activate([
            goButton.heightAnchor.constraint(equalToConstant: 80),
            goButton.widthAnchor.constraint(equalToConstant: 112),
            goButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goButtonBottomConstraint
        ])
        self.goButtonBottomConstraint = goButtonBottomConstraint
    }
    
    private func layoutTypeOfSportButton() {
        view.addSubview(typeOfSportButton)
        typeOfSportButton.translatesAutoresizingMaskIntoConstraints = false
        let typeOfSportButtonBottomConstraint =
            typeOfSportButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        NSLayoutConstraint.activate([
            typeOfSportButton.heightAnchor.constraint(equalToConstant: 80),
            typeOfSportButton.trailingAnchor.constraint(equalTo: goButton.leadingAnchor, constant: -16),
            typeOfSportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            typeOfSportButtonBottomConstraint
        ])
        self.typeOfSportButtonBottomConstraint = typeOfSportButtonBottomConstraint
        
        typeOfSportButton.addSubview(typeOfSportImageView)
        typeOfSportButton.addSubview(typeOfSportLabel)
        typeOfSportImageView.translatesAutoresizingMaskIntoConstraints = false
        typeOfSportLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeOfSportImageView.widthAnchor.constraint(equalTo: typeOfSportImageView.heightAnchor),
            typeOfSportImageView.heightAnchor.constraint(equalToConstant: 64),
            typeOfSportImageView.leadingAnchor.constraint(equalTo: typeOfSportButton.leadingAnchor, constant: 16),
            typeOfSportImageView.centerYAnchor.constraint(equalTo: typeOfSportButton.centerYAnchor),
            
            typeOfSportLabel.leadingAnchor.constraint(equalTo: typeOfSportImageView.trailingAnchor, constant: 16),
            typeOfSportLabel.centerYAnchor.constraint(equalTo: typeOfSportButton.centerYAnchor)
        ])
    }
    
}

extension StartRecordViewController: StartRecordDisplayLogic {
    func displaySportKind(_ sportKind: SportKind) {
        self.sportKind = sportKind
    }
}
