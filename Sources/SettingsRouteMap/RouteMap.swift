//
//  RouteMap.swift
//  
//
//  Created by Арман Чархчян on 04.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import Managers
import Module

public protocol SettingsModuleInput: AnyObject { }

public protocol SettingsModuleOutput: AnyObject {
    func openUnauthorizedZone()
}

public typealias SettingsModule = Module<SettingsModuleInput, SettingsModuleOutput>

public protocol SettingsRouteMap: AnyObject {
    func rootModule() -> SettingsModule
}
