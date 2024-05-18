//
//  SpeciePageVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class SpeciePageVC: UIViewController {
    
    // MARK: - Properties
    private let mainStackView = UIStackView()
    private let tableView = UITableView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let viewModel = SpecieViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backGroundColoring
        setupMainStackView()
        setupSearchBar()
        setupTableView()
        setupErrorLabel()
        setupActivityIndicator()
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchBar() {
        searchTextField.placeholder = "Enter City"
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        
        mainStackView.addArrangedSubview(searchTextField)
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        let searchAction = UIAction { [weak self] _ in
            self?.searchButtonTapped()
        }
        searchButton.addAction(searchAction, for: .touchUpInside)
        
        mainStackView.addArrangedSubview(searchButton)
        searchButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    // MARK: - Actions
    private func searchButtonTapped() {
        guard let cityName = searchTextField.text, !cityName.isEmpty else {
            return
        }
        viewModel.searchButtonDidTap(for: cityName)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view .bottomAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.register(SpecieCell.self, forCellReuseIdentifier: "SpecieCell")
        tableView.backgroundColor = .backGroundColoring
        tableView.layer.cornerRadius = 10
    }
}

// MARK: - UITableViewDataSource
extension SpeciePageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.speciesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecieCell", for: indexPath) as! SpecieCell
        let species = viewModel.speciesInfo[indexPath.row]
        cell.configure(with: species.taxon)
        return cell
    }
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        errorLabel.text = "ინფორმაცია ვერ მოიძებნა"
        errorLabel.textColor = .red
        errorLabel.font = UIFont.boldSystemFont(ofSize: 18)
        errorLabel.isHidden = true
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - SpecieViewModelDelegate
extension SpeciePageVC: SpecieViewModelDelegate {
    
    func didStartFetchingSpeciesData() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.errorLabel.isHidden = true
        }
    }
    
    func didFailToFetchSpeciesData(with error: any Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.viewModel.speciesInfo.removeAll()
            self.errorLabel.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func didFetchSpeciesData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.errorLabel.isHidden = true
            self.tableView.reloadData()
        }
    }
}
