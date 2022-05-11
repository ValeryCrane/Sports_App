//
//  SearchViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation
import UIKit

protocol SearchDisplayLogic: UIViewController {
    func displaySearchResults(_ searchResults: [SearchResult])
}

class SearchViewController: UIViewController {
    var interactor: SearchBusinessLogic!
    var router: SearchRoutingLogic!
    
    private var searchResults: [SearchResult] = [] {
        didSet {
            resultsTableView.reloadData()
        }
    }
    
    private let searchView = UIView()
    private let searchField = TextFieldWithInsets(leftInset: 16, rightInset: 16)
    private let searchButton = UIButton()
    private let resultsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray2
        title = "Search"
        makeKeyboardDismissable()
        setupSearchView()
        setupSearchField()
        setupSearchButton()
        setupResultsTableView()
        layoutSearchView()
        layoutSearchButton()
        layoutSearchField()
        layoutResultsTableView()
        view.bringSubviewToFront(searchView)
    }
    
    private func setupSearchView() {
        searchView.backgroundColor = Colors.gray2
        searchView.addCornerRadiusAndShadow()
        searchView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        searchView.layer.cornerRadius = 8
        searchView.clipsToBounds = false
    }
    
    private func setupSearchField() {
        searchField.backgroundColor = Colors.gray2
        searchField.tintColor = Colors.gray3
        searchField.layer.cornerRadius = 4
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = Colors.gray3.cgColor
        searchField.placeholder = "ID or username"
        searchField.font = UIFont(name: "Jura-Bold", size: 20)
    }
    
    private func setupSearchButton() {
        searchButton.titleLabel?.font = UIFont(name: "Jura-Bold", size: 20)
        searchButton.setTitle("GO", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = Colors.red
        searchButton.layer.cornerRadius = 4
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupResultsTableView() {
        resultsTableView.backgroundColor = Colors.gray2
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        resultsTableView.separatorStyle = .none
    }
    
    private func layoutSearchView() {
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func layoutSearchButton() {
        searchView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 24),
            searchButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -24),
            searchButton.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -24),
            searchButton.heightAnchor.constraint(equalToConstant: 48),
            searchButton.widthAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    private func layoutSearchField() {
        searchView.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 24),
            searchField.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 24),
            searchField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            searchField.heightAnchor.constraint(equalTo: searchButton.heightAnchor)
        ])
    }
    
    public func layoutResultsTableView() {
        view.addSubview(resultsTableView)
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func searchButtonPressed(_ sender: UIButton) {
        interactor.findPeople(query: searchField.text ?? "")
    }
}

extension SearchViewController: UITableViewDelegate { }

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell
        cell?.setup(searchResult: searchResults[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToProfile(userId: searchResults[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: SearchDisplayLogic {
    func displaySearchResults(_ searchResults: [SearchResult]) {
        self.searchResults = searchResults
    }
}
