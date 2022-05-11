//
//  RecordViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 18.04.2022.
//

import Foundation
import UIKit

protocol RecordDisplayLogic: TouchTransparentViewController {
    func displayPauseButton()
    func displayResumeButton()
    func display(distance: String)
}

class RecordViewController: TouchTransparentViewController {
    var interactor: RecordBusinessLogic!
    var router: RecordRoutingLogic!
    
    private let stopButton = UIButton(type: .system)
    private var stopButtonBottomConstraint: NSLayoutConstraint?
    
    private let pauseButton = UIButton(type: .system)
    private var pauseButtonBottomConstraint: NSLayoutConstraint?
    
    private let statisticsButton = UIButton(type: .system)
    private let statisticsImageView = UIImageView()
    private let statisticsLabel = UILabel()
    private var statisticsButtonBottomConstraint: NSLayoutConstraint?
    
    // MARK: - ViewController's life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStopButton()
        layoutStopButton()
        configurePauseButton()
        layoutPauseButton()
        configureStatisticsButton()
        layoutStatisticsButton()
        interactor.startRecord()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statisticsButtonBottomConstraint?.constant = -16
        pauseButtonBottomConstraint?.constant = -16
        stopButtonBottomConstraint?.constant = -16
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Configuration functions.
    private func configureStopButton() {
        stopButton.backgroundColor = Colors.red
        stopButton.layer.cornerRadius = 4
        stopButton.layer.shadowColor = UIColor.black.cgColor
        stopButton.layer.shadowOffset = .zero
        stopButton.layer.shadowRadius = 8
        stopButton.layer.shadowOpacity = 0.1
        
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.tintColor = Colors.gray1
        
        stopButton.addTarget(self, action: #selector(stopButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configurePauseButton() {
        pauseButton.backgroundColor = Colors.gray1
        pauseButton.layer.cornerRadius = 4
        pauseButton.layer.shadowColor = UIColor.black.cgColor
        pauseButton.layer.shadowOffset = .zero
        pauseButton.layer.shadowRadius = 8
        pauseButton.layer.shadowOpacity = 0.1
        
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        pauseButton.tintColor = .black
        
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureStatisticsButton() {
        statisticsButton.backgroundColor = Colors.gray1
        statisticsButton.layer.cornerRadius = 4
        statisticsButton.layer.shadowColor = UIColor.black.cgColor
        statisticsButton.layer.shadowOffset = .zero
        statisticsButton.layer.shadowRadius = 8
        statisticsButton.layer.shadowOpacity = 0.1
        
        statisticsImageView.image = UIImage(named: "statistics")
        statisticsLabel.text = "0m"
        statisticsLabel.font = UIFont(name: "Jura-Bold", size: 24)
        
        statisticsImageView.isUserInteractionEnabled = false
        statisticsLabel.isUserInteractionEnabled = false
        
        statisticsButton.addTarget(self, action: #selector(statisticsButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Layout functions.
    private func layoutStatisticsButton() {
        view.addSubview(statisticsButton)
        statisticsButton.translatesAutoresizingMaskIntoConstraints = false
        let statisticsButtonBottomConstraint =
            statisticsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 104)
        NSLayoutConstraint.activate([
            statisticsButton.heightAnchor.constraint(equalToConstant: 80),
            statisticsButton.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -16),
            statisticsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsButtonBottomConstraint
        ])
        self.statisticsButtonBottomConstraint = statisticsButtonBottomConstraint
        
        statisticsButton.addSubview(statisticsImageView)
        statisticsButton.addSubview(statisticsLabel)
        statisticsImageView.translatesAutoresizingMaskIntoConstraints = false
        statisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statisticsImageView.widthAnchor.constraint(equalTo: statisticsImageView.heightAnchor),
            statisticsImageView.heightAnchor.constraint(equalToConstant: 32),
            statisticsImageView.leadingAnchor.constraint(equalTo: statisticsButton.leadingAnchor, constant: 16),
            statisticsImageView.centerYAnchor.constraint(equalTo: statisticsButton.centerYAnchor),
            
            statisticsLabel.leadingAnchor.constraint(equalTo: statisticsImageView.trailingAnchor, constant: 16),
            statisticsLabel.centerYAnchor.constraint(equalTo: statisticsButton.centerYAnchor)
        ])
    }
    
    private func layoutStopButton() {
        view.addSubview(stopButton)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        let stopButtonBottomConstraint =
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 104)
        NSLayoutConstraint.activate([
            stopButton.heightAnchor.constraint(equalToConstant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 80),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stopButtonBottomConstraint
        ])
        self.stopButtonBottomConstraint = stopButtonBottomConstraint
    }
    
    private func layoutPauseButton() {
        view.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        let pauseButtonBottomConstraint =
            pauseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 104)
        NSLayoutConstraint.activate([
            pauseButton.heightAnchor.constraint(equalToConstant: 80),
            pauseButton.widthAnchor.constraint(equalToConstant: 80),
            pauseButton.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor, constant: -16),
            pauseButtonBottomConstraint
        ])
        self.pauseButtonBottomConstraint = pauseButtonBottomConstraint
    }
    
    @objc private func pauseButtonPressed(_ sender: UIButton) {
        interactor.pauseButtonPressed()
    }
    
    @objc private func statisticsButtonPressed(_ sender: UIButton) {
        router.routeToStatistics()
    }
    
    @objc private func stopButtonPressed(_ sender: UIButton) {
        router.routeToFinishRecordScene()
    }
}

extension RecordViewController: RecordDisplayLogic {
    func displayPauseButton() {
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    func displayResumeButton() {
        pauseButton.setImage(UIImage(named: "resume"), for: .normal)
    }
    
    func display(distance: String) {
        statisticsLabel.text = distance
    }
}

