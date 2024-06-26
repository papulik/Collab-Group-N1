//
//  SolarTableViewCell.swift
//  Collab N1 N-27
//
//  Created by Nika Kakhniashvili on 17.05.24.
//

import UIKit

final class SolarTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SolarTableViewCell"
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Cell
    private func setupCell() {
        contentView.addSubview(dataLabel)
        contentView.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            dataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Configuration
    final func configure(with text: String) {
        dataLabel.text = text
    }
}
