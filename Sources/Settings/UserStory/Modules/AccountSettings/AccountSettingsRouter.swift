//
//  AccountSettingsRouter.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager
import Module

protocol AccountSettingsRouterOutput: AnyObject {
    func acceptToRemove()
    func acceptToExit()
}

protocol AccountSettingsRouterInput: AnyObject {
    func openBlackListModule()
    func openAttentionToRemove()
    func openAttentionToExit()
}

final class AccountSettingsRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    weak var output: AccountSettingsRouterOutput?
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension AccountSettingsRouter: AccountSettingsRouterInput {
    
    func openBlackListModule() {
        let module = routeMap.blackListModule()
        self.push(module)
    }

    func openAttentionToRemove() {
        transitionHandler?.showAlertForRemove(acceptHandler: {
            self.output?.acceptToRemove()
        }, denyHandler: { })
    }

    func openAttentionToExit() {
        transitionHandler?.showAlertForLogout(acceptHandler: {
            self.output?.acceptToExit()
        }, denyHandler: { })
    }
}

private extension AccountSettingsRouter {
    func push(_ module: ModuleProtocol) {
        let transition = PushTransition()
        transition.source = transitionHandler
        transition.destination = module.view
        transition.perform(nil)
    }
}
