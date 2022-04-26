//
//  BlackListAssembly.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Module
import Swinject
import Managers
import AlertManager

typealias BlackListModule = Module<BlackListModuleInput, BlackListModuleOutput>

enum BlackListAssembly {
    static func makeModule(accountManager: AccountManagerProtocol,
                           alertManager: AlertManagerProtocol,
                           routeMap: RouteMapPrivate) -> BlackListModule {
        let view = BlackListViewController()
        let router = BlackListRouter(routeMap: routeMap)
        let interactor = BlackListInteractor(accountManager: accountManager)
        let presenter = BlackListPresenter(router: router,
                                           interactor: interactor,
                                           alertManager: alertManager)
        view.output = presenter
        interactor.output = presenter
        presenter.view = view
        router.transitionHandler = view
        return BlackListModule(input: presenter, view: view) {
            presenter.output = $0
        }
    }
}
