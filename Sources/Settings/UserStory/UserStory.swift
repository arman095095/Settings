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
import Account
import Profile

public protocol SettingsModuleProtocol: AnyObject {
    func rootModule() -> SettingsModule
}

public final class SettingsUserStory {

    private let container: Container
    private var outputWrapper: RootModuleWrapper?

    public init(container: Container) {
        self.container = container
    }
}

extension SettingsUserStory: SettingsModuleProtocol {
    public func rootModule() -> SettingsModule {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension SettingsUserStory: RouteMapPrivate {

    func profileModule(model: ProfileModelProtocol) -> ProfileModule {
        let module = ProfileUserStory(container: container).friendAccountModule(profile: model)
        return module
    }

    func editProfileModule() -> AccountModule {
        let module = AccountUserStory(container: container).editAccountModule()
        return module
    }
    
    func blackListModule() -> BlackListModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = BlackListAssembly.makeModule(authManager: authManager,
                                                  alertManager: alertManager,
                                                  routeMap: self)
        return module
    }
    
    func accountSettingsModule() -> AccountSettingsModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = AccountSettingsAssembly.makeModule(alertManager: alertManager,
                                                        authManager: authManager,
                                                        routeMap: self)
        module.output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
