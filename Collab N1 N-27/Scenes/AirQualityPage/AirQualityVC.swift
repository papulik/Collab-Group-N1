//
//  AirQualityVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class AirQualityVC: UIViewController {
    
    private let viewModel = AirQualityViewModel()
    
    private let latTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter latitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let lonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter longitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Air Quality", for: .normal)
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .lightGray
        
        view.addSubview(latTextField)
        view.addSubview(lonTextField)
        view.addSubview(fetchButton)
        view.addSubview(resultLabel)
        
        latTextField.translatesAutoresizingMaskIntoConstraints = false
        lonTextField.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            latTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latTextField.widthAnchor.constraint(equalToConstant: 200),
            
            lonTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lonTextField.topAnchor.constraint(equalTo: latTextField.bottomAnchor, constant: 20),
            lonTextField.widthAnchor.constraint(equalToConstant: 200),
            
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: lonTextField.bottomAnchor, constant: 20),
            
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        fetchButton.addTarget(self, action: #selector(fetchAirQuality), for: .touchUpInside)
    }
    
    //MARK: - Button Action
    @objc private func fetchAirQuality() {
        guard let latText = latTextField.text, let lat = Double(latText),
              let lonText = lonTextField.text, let lon = Double(lonText) else {
            let alert = UIAlertController(title: "Invalid Lat & Long", message: "Default-ზე მოაქ თბილისი, ამიტომ გთხოვთ ზუსტი კოორდინატები ჩაწეროთ, მადლობა ყურადღებისთვის.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok.", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
            resultLabel.text = "Please enter valid latitude and longitude."
            return
        }
        
        viewModel.fetchAirQuality(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let airQualityInfo):
                DispatchQueue.main.async {
                    self?.updateUI(with: airQualityInfo)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.resultLabel.text = "Error fetching data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func updateUI(with info: AirQualityInfo) {
        resultLabel.text = """
        City: \(info.data.city)
        State: \(info.data.state)
        Country: \(info.data.country)
        
        TS: \(info.data.current.pollution.ts)
        AQI (US): \(info.data.current.pollution.aqius)
        Main Pollutant: \(info.data.current.pollution.mainus)
        Aqicin Pollutant: \(info.data.current.pollution.aqicn)
        MainCN: \(info.data.current.pollution.maincn)
        
        Temperature: \(info.data.current.weather.tp)°C
        Humidity: \(info.data.current.weather.hu)%
        Wind Speed: \(info.data.current.weather.ws) m/s
        """
    }
}
