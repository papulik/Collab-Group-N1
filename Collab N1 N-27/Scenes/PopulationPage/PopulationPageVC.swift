//
//  PopulationPageVC.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

final class PopulationPageVC: UIViewController {
    
    //MARK: - Properties
    var viewModel = PopulationViewModel()
    
    private let safeArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countryInput: UITextField = {
        let input = UITextField()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.placeholder = "Enter Country"
        input.backgroundColor = .white
        input.borderStyle = .roundedRect
        return input
    }()
    
    private let findButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var countryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let todayStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let tomorrowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let todayPopulationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let tomorrowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let tomorrowPopulationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .backGroundColoring
        setupSafeArea()
        setupCountryInput()
        setupFindButton()
        setupCountryNameLabel()
        setupTodayStack()
        setupTomorrowStack()
    }
    
    //MARK: - Constraints
    private func setupSafeArea() {
        view.addSubview(safeArea)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: guide.topAnchor),
            safeArea.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            safeArea.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    private func setupCountryInput() {
        safeArea.addSubview(countryInput)
        NSLayoutConstraint.activate([
            countryInput.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            countryInput.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
            countryInput.widthAnchor.constraint(equalToConstant: 200),
            countryInput.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    //MARK: - Button Setup
    private func setupFindButton() {
        safeArea.addSubview(findButton)
        
        NSLayoutConstraint.activate([
            findButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            findButton.leadingAnchor.constraint(equalTo: countryInput.trailingAnchor, constant: 20),
            findButton.widthAnchor.constraint(equalToConstant: 80),
            findButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        findButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonTapped()
        }), for: .touchUpInside)
    }
    
    //MARK: - Action
    private func buttonTapped() {
        guard let country = countryInput.text?.capitalized else { return }
        
        viewModel.fetchPopulation(country: country) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let populations):
                    self?.updateView(populations: populations)
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
        }
    }
    
    //MARK: Setup Labels
    private func setupCountryNameLabel() {
        safeArea.addSubview(countryName)
        NSLayoutConstraint.activate([
            countryName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            countryName.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -70)
        ])
    }
    
    private func setupTodayStack() {
        safeArea.addSubview(todayStack)
        NSLayoutConstraint.activate([
            todayStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            todayStack.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            todayStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            todayStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40)
        ])
        todayStack.addArrangedSubview(todayLabel)
        todayStack.addArrangedSubview(todayPopulationLabel)
    }
    
    private func setupTomorrowStack() {
        safeArea.addSubview(tomorrowStack)
        NSLayoutConstraint.activate([
            tomorrowStack.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            tomorrowStack.topAnchor.constraint(equalTo: todayStack.bottomAnchor, constant: 20),
            tomorrowStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            tomorrowStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40)
        ])
        tomorrowStack.addArrangedSubview(tomorrowLabel)
        tomorrowStack.addArrangedSubview(tomorrowPopulationLabel)
    }
    
    //MARK: - Updateing View
    private func updateView(populations: [Population]) {
        guard populations.count >= 2 else { return }
        countryName.text = countryInput.text
        todayLabel.text = "Today: \(populations[0].date)"
        todayPopulationLabel.text = "Population: \(populations[0].population)"
        tomorrowLabel.text = "Tomorrow: \(populations[1].date)"
        tomorrowPopulationLabel.text = "Population: \(populations[1].population)"
    }
    
    //MARK: - Error Alert
    private func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
