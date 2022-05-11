//
//  StatisticsViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 26.04.2022.
//

import Foundation
import UIKit

protocol StatisticsDisplayLogic: AnyObject {
    func displayTime(_ time: String)
    func displayStatistics(_ statistics: [Statistic])
}

class StatisticsViewController: UIViewController {
    var interactor: StatisticsBusinessLogic!
    private let timeLabel = UILabel()
    private var statistics = [Statistic]() {
        didSet {
            statisticsTable.reloadData()
        }
    }
    private var statisticsTable = UITableView()
    
    override func viewDidLoad() {
        title = "Statistics"
        view.backgroundColor = .white
        view.backgroundColor = Colors.gray2
        
        configureTimeLabel()
        configureStatisticsTable()
        layoutTimeLabel()
        layoutStatisticsTable()
        
        interactor.update()
    }
    
    private func configureTimeLabel() {
        timeLabel.text = "00:00:00"
        timeLabel.font = UIFont(name: "Jura-Bold", size: 32)
        timeLabel.textAlignment = .center
    }
    
    private func configureStatisticsTable() {
        statisticsTable.dataSource = self
        statisticsTable.delegate = self
        statisticsTable.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.reuseIdentifier)
        statisticsTable.isScrollEnabled = false
        statisticsTable.backgroundColor = Colors.gray2
    }
    
    private func layoutStatisticsTable() {
        view.addSubview(statisticsTable)
        statisticsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statisticsTable.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 24),
            statisticsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statisticsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutTimeLabel() {
        view.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension StatisticsViewController: StatisticsDisplayLogic {
    func displayStatistics(_ statistics: [Statistic]) {
        self.statistics = statistics
    }
    
    func displayTime(_ time: String) {
        timeLabel.text = time
    }
}

extension StatisticsViewController: UITableViewDelegate { }

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.reuseIdentifier, for: indexPath) as? StatisticsCell
        cell?.setup(statistic: statistics[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    
}
