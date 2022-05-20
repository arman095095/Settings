//
//  File.swift
//  
//
//  Created by Арман Чархчян on 22.04.2022.
//

import Foundation
import Swinject
import SettingsRouteMap
import UserStoryFacade

public final class SettingsUserStoryAssembly: Assembly {
    public init() { }
    public func assemble(container: Container) {
        BlockedUsersManagerAssembly().assemble(container: container)
        AccountEscapingManagerAssembly().assemble(container: container)
        container.register(SettingsRouteMap.self) { r in
            SettingsUserStory(container: container)
        }
    }
}
