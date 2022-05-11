//
//  ProfileViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol ProfileDisplayLogic: UIViewController {
    func setActivityButtonType(_ type: ProfileButtonType)
    func displayUsername(_ username: String)
    func displayRides(_ rides: [Ride])
    func displayLastWeekStatistics(_ statistics: [Statistic])
    func endLoading()
}

// ViewController for user's profiles.
class ProfileViewController: UIViewController {
    public static var signDelegate: SignDelegate?
    public var interactor: ProfileBusinessLogic!
    private var rides: [Ride] = [] {
        didSet {
            ridesTableView.reloadData()
        }
    }
    
    private let headerCell = UITableViewCell()
    private let lastWeekStatisticsCell = UITableViewCell()
    private let lastWeekStatisticsView = LastWeekStatisticsView()
    private let usernameLabel = UILabel()
    private let activityButton = UIButton()
    private let ridesTableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    private var activityButtonType: ProfileButtonType?
    
    // MARK: - ViewController's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray2
        title = "Profile"
        configureRidesTableView()
        configureLastWeekStatisticsCell()
        configureOtherViews()
        layoutRidesTableView()
        layoutUsernameLabel()
        layoutActivityButton()
        layoutLastWeekStatisticsCell()
        interactor.fetchData()
    }
    
    // MARK: - Configure functions
    private func configureRidesTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        ridesTableView.refreshControl = refreshControl
        
        ridesTableView.register(RideCell.self, forCellReuseIdentifier: RideCell.reuseIdentifier)
        ridesTableView.delegate = self
        ridesTableView.dataSource = self

        ridesTableView.separatorStyle = .none
        ridesTableView.backgroundColor = .clear
        ridesTableView.showsVerticalScrollIndicator = false
        ridesTableView.isHidden = true
    }
    
    private func configureLastWeekStatisticsCell() {
        lastWeekStatisticsCell.backgroundColor = Colors.gray2
        lastWeekStatisticsCell.selectionStyle = .none
        lastWeekStatisticsCell.layer.cornerRadius = 8
        lastWeekStatisticsCell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        lastWeekStatisticsCell.layer.shadowColor = UIColor.black.cgColor
        lastWeekStatisticsCell.layer.shadowOffset = CGSize(width: 0, height: -4)
        lastWeekStatisticsCell.layer.shadowRadius = 4
        lastWeekStatisticsCell.layer.shadowOpacity = 0.1
    }
    
    private func configureActivityIndicatorView() {
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    private func configureOtherViews() {
        usernameLabel.font = UIFont(name: "Jura-Bold", size: 48)
        activityButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 16)
        headerCell.backgroundColor = .clear
        headerCell.selectionStyle = .none
        headerCell.contentView.isUserInteractionEnabled = false
        activityButton.addTarget(self, action: #selector(activityButtonPressed(_:)), for: .touchUpInside)
    }
    
    // MARK: - Layout functions
    private func layoutRidesTableView() {
        view.addSubview(ridesTableView)
        ridesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ridesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ridesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ridesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ridesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutUsernameLabel() {
        headerCell.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: headerCell.topAnchor, constant: 24).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: headerCell.leadingAnchor, constant: 24).isActive = true
    }
    
    private func layoutActivityButton() {
        activityButton.addCornerRadiusAndShadow()
        headerCell.addSubview(activityButton)
        activityButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16),
            activityButton.leadingAnchor.constraint(equalTo: headerCell.leadingAnchor, constant: 24),
            activityButton.trailingAnchor.constraint(equalTo: headerCell.trailingAnchor, constant: -24),
            activityButton.bottomAnchor.constraint(equalTo: headerCell.bottomAnchor, constant: -24),
            activityButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func layoutLastWeekStatisticsCell() {
        let separator = UIView()
        separator.backgroundColor = Colors.gray3
        lastWeekStatisticsCell.addSubview(separator)
        lastWeekStatisticsCell.addSubview(lastWeekStatisticsView)
        lastWeekStatisticsView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastWeekStatisticsView.topAnchor.constraint(equalTo: lastWeekStatisticsCell.topAnchor, constant: 16),
            lastWeekStatisticsView.leadingAnchor.constraint(equalTo: lastWeekStatisticsCell.leadingAnchor),
            lastWeekStatisticsView.trailingAnchor.constraint(equalTo: lastWeekStatisticsCell.trailingAnchor),
            lastWeekStatisticsView.bottomAnchor.constraint(equalTo: lastWeekStatisticsCell.bottomAnchor, constant: -16),
            
            separator.bottomAnchor.constraint(equalTo: lastWeekStatisticsCell.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: lastWeekStatisticsCell.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: lastWeekStatisticsCell.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Actions
    @objc private func refresh(_ sender: UIRefreshControl) {
        interactor.fetchData()
    }
    
    @objc private func activityButtonPressed(_ sender: UIButton) {
        if activityButtonType == .settings {
            Self.signDelegate?.logOut()
        }
        interactor.processButtonPress(buttonType: activityButtonType ?? .settings)
    }
    
}

// MARK: - ProfileDisplayLogic inplementation
extension ProfileViewController: ProfileDisplayLogic {
    func setActivityButtonType(_ type: ProfileButtonType) {
        self.activityButtonType = type
        switch type {
        case .follow:
            activityButton.setTitle("Follow", for: .normal)
            activityButton.setTitleColor(.white, for: .normal)
            activityButton.backgroundColor = Colors.red
        case .unfollow:
            activityButton.setTitle("Unfollow", for: .normal)
            activityButton.setTitleColor(Colors.red.withAlphaComponent(0.5), for: .normal)
            activityButton.backgroundColor = Colors.gray2
        case .settings:
            activityButton.setTitle("Log out", for: .normal)
            activityButton.setTitleColor(.white, for: .normal)
            activityButton.backgroundColor = Colors.red
        }
    }
    
    func displayUsername(_ username: String) {
        usernameLabel.text = username
    }
    
    func displayRides(_ rides: [Ride]) {
        self.rides = rides
    }
    
    func displayLastWeekStatistics(_ statistics: [Statistic]) {
        lastWeekStatisticsView.setup(statistics: statistics)
    }
    
    func endLoading() {
        ridesTableView.reloadData()
        ridesTableView.refreshControl?.endRefreshing()
        ridesTableView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - UITableViewDelegate & DataSource implementation
extension ProfileViewController: UITableViewDelegate { }

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rides.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return headerCell
        case 1:
            return lastWeekStatisticsCell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RideCell.reuseIdentifier, for: indexPath) as? RideCell
            cell?.setup(ride: rides[indexPath.row - 2])
            return cell ?? UITableViewCell()
        }
    }
    
}

