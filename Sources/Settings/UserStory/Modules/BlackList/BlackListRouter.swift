//
//  BlackListRouter.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers

protocol BlackListRouterInput: AnyObject {
    
}

final class BlackListRouter {
    weak var transitionHandler: UIViewController?
}

extension BlackListRouter: BlackListRouterInput {
    
}
