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
}

extension RootModuleWrapper: SettingsModuleInput { }
