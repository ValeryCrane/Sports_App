//
//  SportKindViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation
import UIKit

class SportKindViewContoller: UIViewController {
    weak var startRecordView: StartRecordDisplayLogic!
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        configureTableView()
        layoutTableView()
        view.backgroundColor = .white
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SportKindCell.self, forCellReuseIdentifier: SportKindCell.reuseIdetifier)
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.rowHeight = 96
    }
    
}

extension SportKindViewContoller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sportKind = SportKind(rawValue: indexPath.row) {
            startRecordView?.displaySportKind(sportKind)
        }
        dismiss(animated: true)
    }
}

extension SportKindViewContoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SportKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SportKindCell.reuseIdetifier, for: indexPath) as? SportKindCell
        if let sportKind = SportKind(rawValue: indexPath.row) {
            cell?.setup(sportKind: sportKind)
        }
        return cell ?? UITableViewCell()
    }
    
}
