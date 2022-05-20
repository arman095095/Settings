//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import Managers
import NetworkServices

final class AccountEscapingManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AccountEscapingManagerProtocol.self) { r in
            guard let quickAccessManager = r.resolve(QuickAccessManagerProtocol.self),
                  let accountService = r.resolve(AccountServiceProtocol.self),
                  let userID = quickAccessManager.userID else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return AccountEscapingManager(accountID: userID,
                                          accountService: accountService,
                                          quickAccessManager: quickAccessManager)
        }
    }
}
