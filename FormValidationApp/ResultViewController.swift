//
//  ResultViewController.swift
//  FormValidationApp
//
//  Created by Mohd Hafiz on 16/10/2022.
//

import UIKit

class ResultViewController: UIViewController {
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Login success"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }

    func setupConstraints() {
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
