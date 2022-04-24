//
//  File.swift
//  
//
//  Created by Арман Чархчян on 17.04.2022.
//

import Foundation

protocol RouteMapPrivate: AnyObject {
    func blackListModule() -> BlackListModule
    func accountSettinsModule() -> AccountSettingsModule
}
