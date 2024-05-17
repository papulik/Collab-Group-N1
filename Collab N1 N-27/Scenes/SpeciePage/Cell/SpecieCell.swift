//
//  SpecieCell.swift
//  Collab N1 N-27
//
//  Created by Bakar Kharabadze on 5/17/24.
//

import UIKit

final class SpecieCell: UITableViewCell {
    // MARK: Properties
    
    private let mainStackView = UIStackView()
    private let nameStackView = UIStackView()
    private let authorStackView = UIStackView()
    
    private let image = UIImageView()
    
    private let name = UILabel()
    private let nameResponse = UILabel()
    
    private let author = UILabel()
    private let authorResponse = UILabel()
    
    private let wikipedia = UILabel()
    private let wikipediaResponse = UILabel()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
        setupMainStackView()
        setupImageView()
        setupNameStackView()
        setupAuthorStackView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupMainStackView() {
        contentView.addSubview(mainStackView)
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupImageView() {
        mainStackView.addArrangedSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
    }
    
    private func setupNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.spacing = 5
        
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.text = "სახელი:"
        name.numberOfLines = 0
        
        nameResponse.font = UIFont.systemFont(ofSize: 16)
        
        nameStackView.addArrangedSubview(name)
        nameStackView.addArrangedSubview(nameResponse)
        
        mainStackView.addArrangedSubview(nameStackView)
    }
    
    private func setupAuthorStackView() {
        authorStackView.axis = .horizontal
        authorStackView.spacing = 5
        
        author.font = UIFont.boldSystemFont(ofSize: 16)
        author.text = "სახეობა:"
        author.numberOfLines = 0
        
        authorResponse.font = UIFont.systemFont(ofSize: 16)
        
        authorStackView.addArrangedSubview(author)
        authorStackView.addArrangedSubview(authorResponse)
        
        mainStackView.addArrangedSubview(authorStackView)
    }
    
    private func setupViews() {
        wikipedia.font = UIFont.boldSystemFont(ofSize: 16)
        wikipedia.text = "ვიკიპედიის ლინკი:"
        wikipedia.numberOfLines = 0
        
        wikipediaResponse.font = UIFont.systemFont(ofSize: 16)
        wikipediaResponse.textColor = .blue
        
        mainStackView.addArrangedSubview(wikipedia)
        mainStackView.addArrangedSubview(wikipediaResponse)
    }
    
    func configure(with speciesInfo: Taxon ) {
        if let imageURL = URL(string: speciesInfo.defaultPhoto?.mediumUrl ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.image.image = UIImage(data: data)
                    }
                }
            }
        }
        nameResponse.text = speciesInfo.name
        authorResponse.text = speciesInfo.preferredCommonName
        wikipediaResponse.text = speciesInfo.wikipediaUrl
    }
}
