//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation
import Account
import Managers
import ProfileRouteMap

protocol RouteMapPrivate: AnyObject {
    func blackListModule() -> BlackListModule
    func accountSettingsModule() -> AccountSettingsModule
    func editProfileModule() -> AccountModule
    func profileModule(model: ProfileModelProtocol) -> ProfileModule
}
