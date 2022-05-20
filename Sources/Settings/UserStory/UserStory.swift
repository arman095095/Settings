//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation
import Module
import Swinject
import Managers
import AlertManager
import AccountRouteMap
import ProfileRouteMap
import SettingsRouteMap
import UserStoryFacade
import ModelInterfaces

public final class SettingsUserStory {

    private let container: Container
    private var outputWrapper: RootModuleWrapper?

    public init(container: Container) {
        self.container = container
    }
}

extension SettingsUserStory: SettingsRouteMap {
    public func rootModule() -> SettingsModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension SettingsUserStory: RouteMapPrivate {

    func profileModule(model: ProfileModelProtocol) -> ProfileModule {
        let safeResolver = container.synchronize()
        guard let profileModule = safeResolver.resolve(UserStoryFacadeProtocol.self)?.profileUserStory else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        let module = profileModule.someAccountModule(profile: model)
        return module
    }

    func editProfileModule() -> AccountModule {
        guard let module = container.synchronize().resolve(UserStoryFacadeProtocol.self)?.accountUserStory?.editAccountModule() else {
            fatalError(ErrorMessage.dependency.localizedDescription)
        }
        return module
    }
    
    func blackListModule() -> BlackListModule {
        let safeResolver = container.synchronize()
        guard let blockingManager = safeResolver.resolve(BlockedUsersManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = BlackListAssembly.makeModule(blockingManager: blockingManager,
                                                  alertManager: alertManager,
                                                  routeMap: self)
        return module
    }
    
    func accountSettingsModule() -> AccountSettingsModule {
        let safeResolver = container.synchronize()
        guard let accountManager = safeResolver.resolve(AccountEscapingManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = AccountSettingsAssembly.makeModule(alertManager: alertManager,
                                                        accountManager: accountManager,
                                                        routeMap: self)
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
