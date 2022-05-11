//
//  NewsCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    public static let reuseIdentifier = "NewsCell"
    
    private let imgView = UIImageView()
    private let titleView = UILabel()
    private let separator = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        configure()
    }
    
    public func setup(newsCellModel: NewsCellModel) {
        titleView.text = newsCellModel.title
        titleView.numberOfLines = 2
        imgView.image = newsCellModel.image
    }
    
    private func configure() {
        imgView.backgroundColor = Colors.gray3
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        titleView.font = UIFont(name: "Jura-Bold", size: 24)
        separator.backgroundColor = Colors.gray3
        backgroundColor = .clear
    }
    
    private func layout() {
        addSubview(imgView)
        addSubview(titleView)
        addSubview(separator)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 200),
            
            titleView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 8),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
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
