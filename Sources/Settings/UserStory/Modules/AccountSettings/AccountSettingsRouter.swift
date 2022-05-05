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
import AccountRouteMap

protocol AccountSettingsRouterOutput: AnyObject {
    func acceptToRemove()
    func acceptToExit()
}

protocol AccountSettingsRouterInput: AnyObject {
    func openBlackListModule()
    func openAttentionToRemove()
    func openAttentionToExit()
    func openEditProfileModule()
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
    func openEditProfileModule() {
        let module = routeMap.editProfileModule()
        self.push(module.view)
    }
    
    func openBlackListModule() {
        let module = routeMap.blackListModule()
        self.push(module.view)
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
    func push(_ view: UIViewController) {
        let transition = PushTransition()
        transition.source = transitionHandler
        transition.destination = view
        transition.perform(nil)
    }
}
