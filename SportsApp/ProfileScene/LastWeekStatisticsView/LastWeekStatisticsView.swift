//
//  LastWeekStatisticsView.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 10.05.2022.
//

import Foundation
import UIKit

// View, which shows last week statistics.
class LastWeekStatisticsView: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        configure()
        layoutTitleLabel()
        layoutStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup functions
    public func setup(statistics: [Statistic]) {
        clearStackView()
        for i in 0 ..< statistics.count {
            let statisticCell = LastWeekStatisticCell(statistic: statistics[i],
                                                       hasSeparator: (i != statistics.count - 1))
            stackView.addArrangedSubview(statisticCell)
            statisticCell.translatesAutoresizingMaskIntoConstraints = false
            statisticCell.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
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
        titleLabel.text = "Last week"
        titleLabel.font = UIFont(name: "Jura-Bold", size: 16)
        titleLabel.textColor = Colors.gray4
        stackView.axis = .horizontal
    }
    
    // MARK: - Layout functions
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])
    }
    
    private func layoutStackView() {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}
