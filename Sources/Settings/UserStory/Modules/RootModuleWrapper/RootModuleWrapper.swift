//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation
import UIKit
import Managers
import Account

public protocol SettingsModuleOutput: AnyObject {
    func openUnauthorizedZone()
    func openEditAccount()
    func openProfileModule(profile: ProfileModelProtocol)
}

public protocol SettingsModuleInput: AnyObject {
    
}

final class RootModuleWrapper {
    private let routeMap: RouteMapPrivate
    weak var output: SettingsModuleOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
    
    func view() -> UIViewController {
        let module = routeMap.accountSettingsModule()
        module.output = self
        return module.view
    }
}

extension RootModuleWrapper: AccountSettingsModuleOutput {
    func logout() {
        output?.openUnauthorizedZone()
    }
    
    func editProfile() {
        output?.openEditAccount()
    }
}

extension RootModuleWrapper: BlackListModuleOutput {
    func openProfileModule(profile: ProfileModelProtocol) {
        output?.openProfileModule(profile: profile)
    }
}

extension RootModuleWrapper: SettingsModuleInput { }
