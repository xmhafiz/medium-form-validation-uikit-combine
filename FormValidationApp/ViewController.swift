//
//  ViewController.swift
//  FormValidationApp
//
//  Created by Mohd Hafiz on 15/10/2022.
//

import Combine
import UIKit

class ViewController: UIViewController {
    var viewModel = LoginViewModel()
    var cancellables = Set<AnyCancellable>()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email.."
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password.."
        textField.isSecureTextEntry = true
        return textField
    }()

    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops, incorrect username or password!"
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupPublisher()
    }

    func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(submitButton)
        stackView.addArrangedSubview(errorLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    func setupPublisher() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
    
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)

        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.submitButton.isEnabled = false
                    self?.submitButton.setTitle("Loading..", for: .normal)
                    self?.hideError(true)
                case .success:
                    self?.showResultScreen()
                    self?.resetButton()
                    self?.hideError(true)
                case .failed:
                    self?.resetButton()
                    self?.hideError(false)
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func onSubmit() {
        viewModel.submitLogin()
    }

    func resetButton() {
        submitButton.setTitle("Login", for: .normal)
        submitButton.isEnabled = true
    }

    func showResultScreen() {
        let homeVC = ResultViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func hideError(_ isHidden: Bool) {
        errorLabel.alpha = isHidden ? 0 : 1
    }
}

