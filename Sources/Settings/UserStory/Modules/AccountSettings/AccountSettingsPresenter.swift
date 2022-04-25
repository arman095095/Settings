//
//  AccountSettingsPresenter.swift
//  
//
//  Created by Арман Чархчян on 15.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import AlertManager

protocol AccountSettingsStringFactoryProtocol {
    var title: String { get }
    var editButtonTitle: String { get }
    var blackListTitle: String { get }
    var removeTitle: String { get }
    var logoutTitle: String { get }
    var successRemovedMessage: String { get }
}

protocol AccountSettingsModuleOutput: AnyObject {
    func logout()
}

protocol AccountSettingsModuleInput: AnyObject {
    
}

protocol AccountSettingsViewOutput: AnyObject {
    func viewDidLoad()
    func editProfileAction()
    func blackListAction()
    func removeProfileAction()
    func logout()
}

final class AccountSettingsPresenter {
    
    weak var view: AccountSettingsViewInput?
    weak var output: AccountSettingsModuleOutput?
    private let router: AccountSettingsRouterInput
    private let interactor: AccountSettingsInteractorInput
    private let stringFactory: AccountSettingsStringFactoryProtocol
    private let alertManager: AlertManagerProtocol
    
    init(router: AccountSettingsRouterInput,
         interactor: AccountSettingsInteractorInput,
         stringFactory: AccountSettingsStringFactoryProtocol,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.stringFactory = stringFactory
        self.alertManager = alertManager
    }
}

extension AccountSettingsPresenter: AccountSettingsViewOutput {

    func viewDidLoad() {
        view?.setupInitialState(stringFactory: stringFactory)
    }
    
    func editProfileAction() {
        router.openEditProfileModule()
    }
    
    func blackListAction() {
        router.openBlackListModule()
    }
    
    func removeProfileAction() {
        router.openAttentionToRemove()
    }
    
    func logout() {
        router.openAttentionToExit()
    }
}

extension AccountSettingsPresenter: AccountSettingsInteractorOutput {
    func failureRemove(message: String) {
        view?.setLoading(on: false)
        alertManager.present(type: .error, title: message)
    }
    
    func successRemove() {
        view?.setLoading(on: false)
        alertManager.present(type: .success,
                             title: stringFactory.successRemovedMessage)
        output?.logout()
    }
}

extension AccountSettingsPresenter: AccountSettingsModuleInput {
    
}

extension AccountSettingsPresenter: AccountSettingsRouterOutput {
    func acceptToRemove() {
        view?.setLoading(on: true)
        interactor.removeProfile()
    }
    
    func acceptToExit() {
        interactor.logout()
        output?.logout()
    }
}
