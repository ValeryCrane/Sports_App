//
//  NewsViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol NewsDisplayLogic: UIViewController {
    func displayNews(_ news: [NewsCellModel])
    func setLoadingFooterEnabled(_ isEnabled: Bool)
}

class NewsViewController: UIViewController {
    var interactor: NewsBusinessLogic!
    var router: NewsRoutingLogic!
    
    private var news: [NewsCellModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let tableView = UITableView()
    private let footerView = UITableViewCell()
    private var isLoadingFooterEnabled = true {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        layoutTableView()
        layoutFooterView()
        interactor.fetchNews(lastArticleIndex: 0)
        view.backgroundColor = Colors.gray2
        title = "News"
    }
    
    private func configureTableView() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.gray2
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutFooterView() {
        let activityIndicator = UIActivityIndicatorView()
        footerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        footerView.backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToWebView(url: news[indexPath.row].url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count + (isLoadingFooterEnabled ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != news.count else { return footerView }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell
        cell?.setup(newsCellModel: news[indexPath.row])
        if indexPath.row == news.count - 1 {
            interactor.fetchNews(lastArticleIndex: news.count)
        }
        return cell ?? UITableViewCell()
    }
    
}

extension NewsViewController: NewsDisplayLogic {
    func displayNews(_ news: [NewsCellModel]) {
        self.news = news
    }
    
    func setLoadingFooterEnabled(_ isEnabled: Bool) {
        isLoadingFooterEnabled = isEnabled
    }
    
}
