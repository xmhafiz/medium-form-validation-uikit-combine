//
//  LoginViewModel.swift
//  TextFieldValidationApp
//
//  Created by Mohd Hafiz on 15/10/2022.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    enum LoginState {
        case loading
        case success
        case failed
        case none
    }
    @Published var email = ""
    @Published var password = ""
    @Published var state: LoginState = .none
    
    var isValidUsernamePublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }

    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }

    func submitLogin() {
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            guard let self = self else { return }
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
    
    func isCorrectLogin() -> Bool {
        // hardcoded example
        return email == "john@example.com" && password == "12345"
    }
}

extension String {
    var isValidEmail: Bool {
        return NSPredicate(
            format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        )
        .evaluate(with: self)
    }
}

