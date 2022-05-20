//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import NetworkServices
import Managers

enum RemoveError: LocalizedError {
    case cantRemove
    public var errorDescription: String? {
        switch self {
        case .cantRemove:
            return "Ошибка при попытке удалить профиль"
        }
    }
}

protocol AccountEscapingManagerProtocol {
    func signOut()
    func removeAccount(completion: @escaping (Result<Void, RemoveError>) -> Void)
}

final class AccountEscapingManager {
    private let accountID: String
    private let accountService: AccountNetworkServiceProtocol
    private let quickAccessManager: QuickAccessManagerProtocol
    
    init(accountID: String,
         accountService: AccountNetworkServiceProtocol,
         quickAccessManager: QuickAccessManagerProtocol) {
        self.accountID = accountID
        self.quickAccessManager = quickAccessManager
        self.accountService = accountService
    }
}

extension AccountEscapingManager: AccountEscapingManagerProtocol {
    public func removeAccount(completion: @escaping (Result<Void, RemoveError>) -> Void) {
        accountService.removeAccount(accountID: accountID) { [weak self] error in
            if let _ = error {
                completion(.failure(.cantRemove))
                return
            }
            self?.signOut()
            completion(.success(()))
        }
    }
    
    public func signOut() {
        setOffline()
        quickAccessManager.clearAll()
    }
    
    private func setOffline() {
        accountService.setOffline(accountID: accountID)
    }
}
