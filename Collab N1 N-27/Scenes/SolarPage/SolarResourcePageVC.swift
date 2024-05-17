//
//  SolarResourcePageVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

class SolarResourcePageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var viewModel = SolarDataViewModel()
    var tableView = UITableView()
    var addressTextField = UITextField()
    var fetchButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }

    func setupViews() {
        view.backgroundColor = .white
        
        // Setup latTextField
        addressTextField.placeholder = "Enter address"
        addressTextField.borderStyle = .roundedRect
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressTextField)
        
        // Setup fetchButton
        fetchButton.setTitle("Fetch Solar Data", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fetchButton)
        
        // Setup tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(SolarTableViewCell.self, forCellReuseIdentifier: SolarTableViewCell.identifier)
        
        // Add constraints
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            fetchButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func fetchButtonTapped() {
        guard let address = addressTextField.text, !address.isEmpty
        else {
            // Show an alert if address is empty
            showAlert(message: "Please enter the address")
            return
        }
        
        viewModel.fetchSolarData(address: address) { result in
            switch result {
            case .success(_):
                print("Data fetched successfully")
                // Update your tableView with the new data
                self.tableView.reloadData()
            case .failure(let error):
                // Handle the error (e.g., show an alert)
                self.showAlert(message: "Failed to fetch data: \(error.localizedDescription)")
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of rows based on data
        if let solarData = viewModel.solarData {
            return 3 + solarData.avgDNI.monthly.count // DNI, GHI, LatTilt + Monthly data
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
