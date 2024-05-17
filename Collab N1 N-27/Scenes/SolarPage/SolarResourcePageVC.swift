//
//  SolarResourcePageVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class SolarResourcePageVC: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = SolarDataViewModel()
    private var tableView = UITableView()
    private var addressTextField = UITextField()
    private var fetchButton = UIButton(type: .system)
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .gray
        
        // Setup latTextField
        addressTextField.placeholder = "Enter address"
        addressTextField.borderStyle = .roundedRect
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTextField)
        
        // Setup fetchButton
        fetchButton.setTitle("Fetch Solar", for: .normal)
        fetchButton.tintColor = .white
        fetchButton.backgroundColor = .systemBlue
        fetchButton.layer.cornerRadius = 10
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fetchButton)
        
        // Setup tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(SolarTableViewCell.self, forCellReuseIdentifier: SolarTableViewCell.identifier)
        tableView.backgroundColor = .gray
        
        // Add constraints
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fetchButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Actions
    
    @objc private func fetchButtonTapped() {
        guard let address = addressTextField.text, !address.isEmpty
        else {
            // Show an alert if address is empty
            showAlert(message: "Please enter the address")
            return
        }
        
        viewModel.fetchSolarData(address: address) { result in
            switch result {
            case .success(_):
                
                DispatchQueue.main.async {
                    print("Data fetched successfully")
                    self.tableView.reloadData()
                }
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "Try correct address/city name (for example: Arizona")
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension SolarResourcePageVC: UITableViewDataSource {
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of rows based on data
        if let solarData = viewModel.solarData {
            return 3 + solarData.avgDNI.monthly.count // DNI, GHI, LatTilt + Monthly data
        }
        return 0
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SolarTableViewCell.identifier, for: indexPath) as? SolarTableViewCell,
              let solarData = viewModel.solarData else { return UITableViewCell() }
        
        let index = indexPath.row
        
        if index == 0 {
            cell.configure(with: "Average DNI (annual): \(solarData.avgDNI.annual)")
        } else if index == 1 {
            cell.configure(with: "Average GHI (annual): \(solarData.avgGHI.annual)")
        } else if index == 2 {
            cell.configure(with: "Average LatTilt (annual): \(solarData.avgLatTilt.annual)")
        } else {
            let monthIndex = index - 3
            let monthKeys = Array(solarData.avgDNI.monthly.keys.sorted())
            let month = monthKeys[monthIndex]
            let dniValue = solarData.avgDNI.monthly[month] ?? 0
            let ghiValue = solarData.avgGHI.monthly[month] ?? 0
            let latTiltValue = solarData.avgLatTilt.monthly[month] ?? 0
            cell.configure(with: "\(month.capitalized): DNI: \(dniValue), GHI: \(ghiValue), LatTilt: \(latTiltValue)")
        }
        
        return cell
    }
    
}
