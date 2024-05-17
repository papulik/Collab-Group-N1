//
//  WeatherPageVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class WeatherPageVC: UIViewController {
    
    private let viewModel = WeatherViewModel()
    private let tableView = UITableView()
    private let cityLabel = UILabel()
    private let cityTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        let inputStackView = UIStackView()
        inputStackView.axis = .vertical
        inputStackView.spacing = 8.0
        inputStackView.alignment = .fill
        inputStackView.distribution = .fill
        
        cityTextField.placeholder = "Enter city name"
        cityTextField.borderStyle = .roundedRect
        inputStackView.addArrangedSubview(cityTextField)
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.searchButtonTapped()
        }), for: .touchUpInside)
        inputStackView.addArrangedSubview(searchButton)
        
        view.addSubview(inputStackView)
        view.addSubview(cityLabel)
        
        view.addSubview(tableView)
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cityLabel.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 16),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func searchButtonTapped() {
        guard let input = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
            showAlert(message: Constants.noInputMessage)
            return
        }
        
        guard input.range(of: "^[a-zA-Z\\s]+$", options: .regularExpression) != nil else {
            showAlert(message: Constants.cityNameLatinAlphabetMessage)
            return
        }
        
        viewModel.fetchWeather(for: input) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.cityLabel.text = self?.viewModel.cityName
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: Constants.cityNameErrorMessage)
                }
                print(error)
            }
        }
    }
    
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfForecasts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let forecast = viewModel.forecast(at: indexPath.row) {
            let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateFormat
            let dateString = dateFormatter.string(from: date)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "\(dateString): Temp: \(forecast.main.temp)°C, \(forecast.weather.first?.description ?? "")"
        }
        return cell
    }
}
