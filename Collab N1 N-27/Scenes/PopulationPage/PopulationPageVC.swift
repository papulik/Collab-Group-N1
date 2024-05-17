
    import UIKit
     
    final class PopulationPageVC: UIViewController {
        
        var viewModel = PopulationViewModel()
        
        private let safeArea: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let countryInput: UITextField = {
            let input = UITextField()
            input.placeholder = "Enter Country"
            input.translatesAutoresizingMaskIntoConstraints = false
            input.backgroundColor = .systemBackground
            return input
        }()
        
        private let findButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Find", for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            return button
        }()
        
        private var countryName: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .boldSystemFont(ofSize: 16)
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
            return label
        }()
        
        private let todayPopulationLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let tomorrowLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let tomorrowPopulationLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
        private func setupUI() {
            view.backgroundColor = .lightGray
            setupSafeArea()
            setupCountryInput()
            setupFindButton()
            setupCountryNameLabel()
            setupTodayStack()
            setupTomorrowStack()
        }
        
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
                countryInput.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
                countryInput.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 50),
                countryInput.widthAnchor.constraint(equalToConstant: 200),
                countryInput.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        private func setupFindButton() {
            findButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            safeArea.addSubview(findButton)
            NSLayoutConstraint.activate([
                findButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
                findButton.leadingAnchor.constraint(equalTo: countryInput.trailingAnchor, constant: 20),
                findButton.widthAnchor.constraint(equalToConstant: 80),
                findButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
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
        
        @objc private func tapped() {
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
        
        private func updateView(populations: [Population]) {
            guard populations.count >= 2 else { return }
            countryName.text = countryInput.text
            todayLabel.text = "Today: \(populations[0].date)"
            todayPopulationLabel.text = "Population: \(populations[0].population)"
            tomorrowLabel.text = "Tomorrow: \(populations[1].date)"
            tomorrowPopulationLabel.text = "Population: \(populations[1].population)"
        }
        
        private func showError(error: Error) {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
