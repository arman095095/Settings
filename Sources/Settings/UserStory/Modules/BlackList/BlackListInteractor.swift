//
//  BlackListInteractor.swift
//  
//
//  Created by Арман Чархчян on 16.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Managers
import ModelInterfaces

protocol BlackListInteractorInput: AnyObject {
    func getBlockedProfiles()
    func unblock(profile: ProfileModelProtocol)
}

protocol BlackListInteractorOutput: AnyObject {
    func successGetBlockedProfiles(profiles: [ProfileModelProtocol])
    func failureGetBlockedProfiles(message: String)
    func failureUnblockProfile(message: String)
}

final class BlackListInteractor {
    
    weak var output: BlackListInteractorOutput?
    private let blockingManager: BlockedUsersManagerProtocol
    
    init(blockingManager: BlockedUsersManagerProtocol) {
        self.blockingManager = blockingManager
    }
}

extension BlackListInteractor: BlackListInteractorInput {

    func unblock(profile: ProfileModelProtocol) {
        blockingManager.unblockProfile(profile.id) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.output?.failureUnblockProfile(message: error.localizedDescription)
            }
        }
    }
    
    func getBlockedProfiles() {
        blockingManager.blockedProfiles { [weak self] result in
            switch result {
            case .success(let profiles):
                self?.output?.successGetBlockedProfiles(profiles: profiles)
            case .failure(let error):
                self?.output?.failureGetBlockedProfiles(message: error.localizedDescription)
            }
        }
    }
}
