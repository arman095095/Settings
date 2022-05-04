//
//  BlackListRouter.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import ModelInterfaces

protocol BlackListRouterInput: AnyObject {
    func openProfileModule(profile: ProfileModelProtocol)
}

final class BlackListRouter {
    weak var transitionHandler: UIViewController?
    private let routeMap: RouteMapPrivate
    
    init(routeMap: RouteMapPrivate) {
        self.routeMap = routeMap
    }
}

extension BlackListRouter: BlackListRouterInput {
    func openProfileModule(profile: ProfileModelProtocol) {
        let module = routeMap.profileModule(model: profile)
        transitionHandler?.navigationController?.pushViewController(module.view, animated: true)
    }
}
