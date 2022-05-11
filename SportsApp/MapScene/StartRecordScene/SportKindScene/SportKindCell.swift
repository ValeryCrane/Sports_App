//
//  SportKindCell.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 05.05.2022.
//

import Foundation
import UIKit

class SportKindCell: UITableViewCell {
    public static let reuseIdetifier = "SportKindCell"
    
    private let imgView = UIImageView()
    private let sportLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(sportKind: SportKind) {
        imgView.image = sportKind.getImage()
        sportLabel.text = sportKind.getName()
    }
    
    private func configure() {
        sportLabel.font = UIFont(name: "Jura-Bold", size: 24)
    }
    
    private func layout() {
        self.addSubview(imgView)
        self.addSubview(sportLabel)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        sportLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: 64),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            sportLabel.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            sportLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16)
        ])
    }
    
    
}
