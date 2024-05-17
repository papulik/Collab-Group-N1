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
    
    var viewModel = SpecieViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .lightGray
        setupMainStackView()
        setupSearchBar()
        setupTableView()
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
        searchTextField.placeholder = "შეიყვანეთ ქალაქი"
        searchTextField.borderStyle = .roundedRect
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        
        mainStackView.addArrangedSubview(searchTextField)
        
        searchButton.setTitle("ძებნა", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        mainStackView.addArrangedSubview(searchButton)
        searchButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        guard let cityName = searchTextField.text, !cityName.isEmpty else {
            return
        }
        viewModel.searchButtonDidTap(for: cityName)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view .bottomAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.register(SpecieCell.self, forCellReuseIdentifier: "SpecieCell")
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
}

// MARK: - SpecieViewModelDelegate
extension SpeciePageVC: SpecieViewModelDelegate {
    func didFetchSpeciesData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
