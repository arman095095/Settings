//
//  AccountSettingsInteractor.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol AccountSettingsInteractorInput: AnyObject {
    func removeProfile()
    func logout()
}

protocol AccountSettingsInteractorOutput: AnyObject {
    func failureRemove(message: String)
    func successRemove()
}

final class AccountSettingsInteractor {
    
    weak var output: AccountSettingsInteractorOutput?
    private let accountManager: AccountEscapingManagerProtocol
    
    init(accountManager: AccountEscapingManagerProtocol) {
        self.accountManager = accountManager
    }
}

extension AccountSettingsInteractor: AccountSettingsInteractorInput {

    func removeProfile() {
        accountManager.removeAccount { [weak self] result in
            switch result {
            case .success:
                self?.output?.successRemove()
            case .failure(let error):
                self?.output?.failureRemove(message: error.localizedDescription)
            }
        }
    }
    
    func logout() {
        accountManager.signOut()
    }
}
