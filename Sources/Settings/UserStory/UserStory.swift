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

public protocol SettingsModuleProtocol: AnyObject {
    func rootModule() -> ModuleProtocol
}

public final class SettingsUserStory {

    private let container: Container
    private var outputWrapper: RootModuleWrapper?

    public init(container: Container) {
        self.container = container
    }
}

extension SettingsUserStory: SettingsModuleProtocol {
    public func rootModule() -> ModuleProtocol {
        let module = RootModuleWrapperAssembly.makeModule(routeMap: self)
        outputWrapper = module.input as? RootModuleWrapper
        return module
    }
}

extension SettingsUserStory: RouteMapPrivate {
    func blackListModule() -> BlackListModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = BlackListAssembly.makeModule(authManager: authManager,
                                                  alertManager: alertManager)
        module._output = outputWrapper
        return module
    }
    
    func accountSettinsModule() -> AccountSettingsModule {
        let safeResolver = container.synchronize()
        guard let authManager = safeResolver.resolve(AuthManagerProtocol.self),
              let alertManager = safeResolver.resolve(AlertManagerProtocol.self) else { fatalError(ErrorMessage.dependency.localizedDescription) }
        let module = AccountSettingsAssembly.makeModule(alertManager: alertManager,
                                                        authManager: authManager,
                                                        routeMap: self)
        module._output = outputWrapper
        return module
    }
}

enum ErrorMessage: LocalizedError {
    case dependency
}
