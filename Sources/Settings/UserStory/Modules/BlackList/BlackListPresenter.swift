//
//  BlackListPresenter.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem
import Managers
import AlertManager
import ModelInterfaces

protocol BlackListModuleOutput: AnyObject {
    
}

protocol BlackListModuleInput: AnyObject {
    
}

protocol BlackListViewOutput: AnyObject {
    var numberOfRows: Int { get }
    func viewDidLoad()
    func viewWillAppear()
    func remove(at indexPath: IndexPath)
    func select(at indexPath: IndexPath)
    func profile(at indexPath: IndexPath) -> ListCellViewModelProtocol?
}

final class BlackListPresenter {
    
    weak var view: BlackListViewInput?
    weak var output: BlackListModuleOutput?
    private let router: BlackListRouterInput
    private let interactor: BlackListInteractorInput
    private var profiles: [ProfileModelProtocol]?
    private let alertManager: AlertManagerProtocol
    
    init(router: BlackListRouterInput,
         interactor: BlackListInteractorInput,
         alertManager: AlertManagerProtocol) {
        self.router = router
        self.interactor = interactor
        self.alertManager = alertManager
    }
}

extension BlackListPresenter: BlackListViewOutput {
    
    func viewDidLoad() {
        view?.setupInitialState()
        view?.setLoading(on: true)
    }
    
    func viewWillAppear() {
        interactor.getBlockedProfiles()
    }
    
    var numberOfRows: Int {
        profiles?.count ?? 0
    }
    
    func remove(at indexPath: IndexPath) {
        guard let profile = profiles?.remove(at: indexPath.row) else { return }
        interactor.unblock(profile: profile)
    }
    
    func select(at indexPath: IndexPath) {
        guard let profile = profiles?[indexPath.row] else { return }
        router.openProfileModule(profile: profile)
    }
    
    func profile(at indexPath: IndexPath) -> ListCellViewModelProtocol? {
        guard let profile = profiles?[indexPath.row],
              let url = URL(string: profile.imageUrl) else { return nil }
        return ListCellViewModel(name: profile.userName, imageURL: url)
    }
}

extension BlackListPresenter: BlackListInteractorOutput {

    func failureUnblockProfile(message: String) {
        alertManager.present(type: .error, title: message)
    }
    
    func successGetBlockedProfiles(profiles: [ProfileModelProtocol]) {
        view?.setLoading(on: false)
        self.profiles = profiles
        view?.reloadData()
    }
    
    func failureGetBlockedProfiles(message: String) {
        view?.setLoading(on: false)
        view?.reloadData()
        alertManager.present(type: .error, title: message)
    }
}

extension BlackListPresenter: BlackListModuleInput {
    
}
