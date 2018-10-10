//
//  EnterPasswordViewModel.swift
//  HyperlootWallet
//
//  Created by Valery Vaskabovich on 9/24/18.
//  Copyright © 2018 Hyperloot DAO. All rights reserved.
//

import Foundation

class EnterPasswordViewModel {
    
    typealias NextStepCompletion = (ScreenRoute?) -> Void
    
    struct Presentation {
        let isConfirmPasswordHidden: Bool
        let isErrorViewHidden: Bool
        let isNextButtonEnabled: Bool
    }
    
    private var user: UserRegistrationFlow
    
    private var password: String?
    private var confirmPassword: String?
    
    public private(set) var registeredUser: UserRegistrationFlow?
    
    public private(set) lazy var presentation: Presentation = self.buildPresentation()
    
    init(user: UserRegistrationFlow) {
        self.user = user
    }
    
    private func buildPresentation(hideErrorView: Bool = true) -> Presentation {
        switch user {
        case .email(_, userType: let userType):
            return Presentation(isConfirmPasswordHidden: userType == .existing,
                                isErrorViewHidden: hideErrorView,
                                isNextButtonEnabled: isNextButtonEnabled(userType: userType))
        case .emailAndPassword(_, _),
             .createWallet(_, _, _),
             .importWallet(email: _, password: _, importType: _):
            
            // All other cases are not supported
            return Presentation(isConfirmPasswordHidden: true, isErrorViewHidden: false, isNextButtonEnabled: false)
        }
    }
    
    private func isNextButtonEnabled(userType: UserRegistrationFlow.UserType) -> Bool {
        switch userType {
        case .new:
            return doPasswordsMatch()
        case .existing:
            let isPasswordEmpty = password?.isEmpty ?? true
            return isPasswordEmpty == false
        }
    }
    
    private func doPasswordsMatch() -> Bool {
        guard let password = password, let confirmPassword = confirmPassword else {
            return false
        }
        
        return password == confirmPassword
    }
    
    // MARK: - Actions
    
    public func didChangePassword(_ value: String?) {
        password = value
        updatePresentation()
    }
    
    public func didChangeConfirmPassword(_ value: String?) {
        confirmPassword = value
        updatePresentation()
    }
    
    public func updatePresentation() {
        let shouldHideErrorView = doPasswordsMatch()
        presentation = self.buildPresentation(hideErrorView: shouldHideErrorView)
    }
    
    public func proceedToTheNextStep(completion: @escaping NextStepCompletion) {
        switch user {
        case .email(let email, userType: let userType):
            switch userType {
            case .new(nickname: let nickname):
                createNewAccount(email: email, nickname: nickname, completion: completion)
            case .existing:
                proceedWithExistingUser(email: email, completion: completion)
            }
            
        case .emailAndPassword(_, _),
             .createWallet(_, _, _),
             .importWallet(email: _, password: _, importType: _):
            
            // All other cases are not supported
            completion(nil)
        }
    }
    
    private func proceedWithExistingUser(email: String, completion: @escaping NextStepCompletion) {
        guard let password = password else {
            return
        }
        
        registeredUser = .emailAndPassword(email: email, password: password)
        completion(.showImportOrCreateScreen)
    }
    
    private func createNewAccount(email: String, nickname: HyperlootNickname, completion: @escaping NextStepCompletion) {
        guard doPasswordsMatch(), let password = password else {
            return
        }
        
        Hyperloot.shared.createWallet(email: email, nickname: nickname, password: password) { [weak self] (_, words, error) in
            guard let words = words else {
                completion(nil)
                return
            }
            
            self?.registeredUser = .createWallet(email: email, password: password, mnemonicPhrase: words)
            completion(.showEnterWalletKeysScreen)
        }
    }
}
