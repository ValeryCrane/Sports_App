//
//  FeedViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol FeedDisplayLogic: UIViewController {
    func displayFeed(_ rides: [Ride])
}

class FeedViewController: UIViewController {
    var interactor: FeedBusinessLogic!
    var router: FeedRoutingLogic!
    
    private var feed: [Ride] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    private let feedTableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        view.backgroundColor = Colors.gray2
        title = "Feed"
        activityIndicator.startAnimating()
        interactor.fetchFeed()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "News", style: .plain, target: self, action: #selector(openNews(_:)))
    }
    
    private func configure() {
        feedTableView.register(RideCell.self, forCellReuseIdentifier: RideCell.reuseIdentifier)
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.separatorStyle = .none
        feedTableView.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        feedTableView.refreshControl = refreshControl
        feedTableView.showsVerticalScrollIndicator = false
    }
    
    private func layout() {
        view.addSubview(feedTableView)
        view.addSubview(activityIndicator)
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    @objc private func openNews(_ sender: UIBarButtonItem) {
        router.routeToNews()
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        interactor.fetchFeed()
    }
}

extension FeedViewController: UITableViewDelegate { }

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RideCell.reuseIdentifier, for: indexPath) as? RideCell
        cell?.setup(ride: feed[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
}

extension FeedViewController: FeedDisplayLogic {
    func displayFeed(_ rides: [Ride]) {
        self.feed = rides
        activityIndicator.stopAnimating()
        feedTableView.refreshControl?.endRefreshing()
    }
}
