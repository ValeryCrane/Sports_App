//
//  RideStatisticsView.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 10.05.2022.
//

import Foundation
import UIKit

// View for all statistics in RideCell.
class RideStatisticsView: UIView {
    private var statistics: [Statistic] = []
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        configure()
        layout()
    }
    
    // MARK: - Setup functions
    public func setup(statistics: [Statistic]) {
        clearStackView()
        for i in 0 ..< statistics.count {
            let statisticCell = LastWeekStatisticCell(statistic: statistics[i],
                                                       hasSeparator: (i != statistics.count - 1))
            stackView.addArrangedSubview(statisticCell)
            statisticCell.translatesAutoresizingMaskIntoConstraints = false
            statisticCell.widthAnchor.constraint(equalToConstant: 168).isActive = true
        }
    }
    
    private func clearStackView() {
        let views = stackView.arrangedSubviews
        for view in views {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Configure functions
    private func configure() {
        stackView.axis = .horizontal
    }
    
    // MARK: - Layout functions
    private func layout() {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

