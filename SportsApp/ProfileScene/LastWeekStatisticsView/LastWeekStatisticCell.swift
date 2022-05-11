//
//  LastWeekStatisticCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 10.05.2022.
//

import Foundation
import UIKit

// View for single statistic in LastWeekStatisticsView.
class LastWeekStatisticCell: UIView {
    private let featureLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    
    init(statistic: Statistic, hasSeparator separator: Bool) {
        super.init(frame: .zero)
        configure(shouldAddSeparator: separator)
        layout()
        
        featureLabel.text = statistic.feature
        valueLabel.text = String(format: "%.1f", statistic.value)
        unitLabel.text = statistic.unit
    }
    
    // MARK: - Configure functions
    private func configure(shouldAddSeparator separator: Bool) {
        featureLabel.font = UIFont(name: "Jura-Regular", size: 16)
        featureLabel.textColor = Colors.gray4
        valueLabel.font = UIFont(name: "Jura-Bold", size: 24)
        unitLabel.font = UIFont(name: "Jura-Regular", size: 16)
        unitLabel.textColor = Colors.gray4
        if separator { configureSeparator() }
    }
    
    private func configureSeparator() {
        let separator = UIView()
        separator.backgroundColor = Colors.gray3
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Layout functions
    private func layout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -4
        stackView.addArrangedSubview(featureLabel)
        stackView.addArrangedSubview(valueLabel)
        stackView.addArrangedSubview(unitLabel)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
