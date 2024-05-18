//
//  AirQualityVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class AirQualityVC: UIViewController {
    
    //MARK: - Properties
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
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let qualityIndexImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AirQualityImage")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.backgroundColor = UIColor.backGroundColoring.cgColor
        return imageView
    }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionForFetchingButton()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .backGroundColoring
        
        view.addSubview(latTextField)
        view.addSubview(lonTextField)
        view.addSubview(fetchButton)
        view.addSubview(resultLabel)
        view.addSubview(qualityIndexImage)
        
        latTextField.translatesAutoresizingMaskIntoConstraints = false
        lonTextField.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        qualityIndexImage.translatesAutoresizingMaskIntoConstraints = false
        
        constraintsUI()
    }
    
    private func constraintsUI() {
        NSLayoutConstraint.activate([
            latTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            latTextField.widthAnchor.constraint(equalToConstant: 200),
            
            lonTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lonTextField.topAnchor.constraint(equalTo: latTextField.bottomAnchor, constant: 20),
            lonTextField.widthAnchor.constraint(equalToConstant: 200),
            
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: lonTextField.bottomAnchor, constant: 20),
            fetchButton.widthAnchor.constraint(equalToConstant: 150),
            
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            qualityIndexImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qualityIndexImage.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            qualityIndexImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            qualityIndexImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            qualityIndexImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func actionForFetchingButton() {
        let fetchAction = UIAction { [weak self] _ in
            self?.fetchAirQuality()
        }
        fetchButton.addAction(fetchAction, for: .touchUpInside)
    }
    
    //MARK: - Button Action
    private func fetchAirQuality() {
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
    
    //MARK: - Update UI
    private func updateUI(with info: AirQualityInfo) {
        resultLabel.textColor = .white
        resultLabel.text = """
        City: \(info.data.city)
        Country: \(info.data.country)
        
        TS: \(info.data.current.pollution.ts)
        AQI (US): \(info.data.current.pollution.aqius)
        Main Pollutant: \(info.data.current.pollution.mainus)
        Aqicin Pollutant: \(info.data.current.pollution.aqicn)
        MainCN: \(info.data.current.pollution.maincn)
        
        Humidity: \(info.data.current.weather.hu)%
        Wind Speed: \(info.data.current.weather.ws) m/s
        """
    }
}
