//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation
import Module
import SettingsRouteMap

enum RootModuleWrapperAssembly {
    static func makeModule(routeMap: RouteMapPrivate) -> SettingsModule {
        let wrapper = RootModuleWrapper(routeMap: routeMap)
        let module = SettingsModule(input: wrapper, view: wrapper.view()) {
            wrapper.output = $0
        }
        return module
    }
}
