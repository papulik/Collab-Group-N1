//
//  WeatherTableViewCell.swift
//  Collab N1 N-27
//
//  Created by valeri mekhashishvili on 17.05.24.
//

import UIKit


final class WeatherTableViewCell: UITableViewCell {
    let dateLabel = UILabel()
    let tempLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, tempLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with forecast: WeatherInfo.WeatherForecast) {
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = dateFormatter.string(from: date)
        tempLabel.text = "Temp: \(forecast.main.temp)°C"
        descriptionLabel.text = forecast.weather.first?.description ?? ""
    }
}
