//
//  StatisticsCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 27.04.2022.
//

import Foundation
import UIKit

class StatisticsCell: UITableViewCell {
    public static let reuseIdentifier = "StatisticsCell"
    
    private let valueLabel = UILabel()
    private let parameterLabel = UILabel()
    private let unitLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        layout()
    }
    
    func setup(statistic: Statistic) {
        valueLabel.text = String(format: "%.2f", statistic.value)
        parameterLabel.text = statistic.feature
        unitLabel.text = statistic.unit
        backgroundColor = .clear
    }
    
    private func configure() {
        valueLabel.font = UIFont(name: "Jura-Bold", size: 48)
        parameterLabel.font = UIFont(name: "Jura-Bold", size: 16)
        unitLabel.font = UIFont(name: "Jura-Bold", size: 16)
        
        parameterLabel.textColor = Colors.gray4
        unitLabel.textColor = Colors.gray4
    }
    
    private func layout() {
        addSubview(valueLabel)
        addSubview(parameterLabel)
        addSubview(unitLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        parameterLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            parameterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 56),
            parameterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            parameterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            unitLabel.topAnchor.constraint(equalTo: topAnchor, constant: 56),
            unitLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
