//
//  AccountSettingsAssembly.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import AlertManager
import Managers

typealias AccountSettingsModule = Module<AccountSettingsModuleInput, AccountSettingsModuleOutput>

enum AccountSettingsAssembly {
    static func makeModule(alertManager: AlertManagerProtocol,
                           authManager: AuthManagerProtocol,
                           routeMap: RouteMapPrivate) -> AccountSettingsModule {
        let view = AccountSettingsViewController()
        let router = AccountSettingsRouter(routeMap: routeMap)
        let interactor = AccountSettingsInteractor(authManager: authManager)
        let stringFactory = SettingsStringFactory()
        let presenter = AccountSettingsPresenter(router: router,
                                                 interactor: interactor,
                                                 stringFactory: stringFactory,
                                                 alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        router.output = presenter
        return AccountSettingsModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
