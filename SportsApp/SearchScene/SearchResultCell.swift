//
//  SearchResultCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    public static let reuseIdentifier = "SearchResultCell"
    
    private let nameLabel = UILabel()
    private let idLabel = UILabel()
    private let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        layout()
    }
    
    public func setup(searchResult: SearchResult) {
        nameLabel.text = searchResult.name
        idLabel.text = "ID: \(searchResult.id)"
    }
    
    private func configure() {
        nameLabel.font = UIFont(name: "Jura-Bold", size: 24)
        idLabel.font = UIFont(name: "Jura-Bold", size: 16)
        idLabel.textColor = Colors.gray3
        idLabel.textAlignment = .right
        backgroundColor = .clear
        separator.backgroundColor = Colors.gray3
    }
    
    private func layout() {
        addSubview(nameLabel)
        addSubview(idLabel)
        addSubview(separator)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            idLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            idLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
