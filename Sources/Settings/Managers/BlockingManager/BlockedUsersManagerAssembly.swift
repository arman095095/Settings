//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import Swinject
import Managers
import Services
import ModelInterfaces
import NetworkServices

final class BlockedUsersManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BlockedUsersManagerProtocol.self) { r in
            guard let accountID = r.resolve(QuickAccessManagerProtocol.self)?.userID,
                  let account = r.resolve(AccountModelProtocol.self),
                  let accountService = r.resolve(AccountServiceProtocol.self),
                  let cacheService = r.resolve(AccountCacheServiceProtocol.self),
                  let profileService = r.resolve(ProfilesServiceProtocol.self) else {
                fatalError(ErrorMessage.dependency.localizedDescription)
            }
            return BlockedUsersManager(account: account,
                                       accountID: accountID,
                                       accountService: accountService,
                                       profileService: profileService,
                                       cacheService: cacheService)
        }
    }
}

